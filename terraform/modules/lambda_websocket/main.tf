data "aws_iam_policy_document" "ws_api_gateway_policy" {
  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    effect    = "Allow"
    resources = [var.lambda_arn]
  }
}

resource "aws_iam_policy" "ws_api_gateway_policy" {
  name   = "${var.api_name}-WS-APIGatewayPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.ws_api_gateway_policy.json
  tags   = var.tags
}

resource "aws_iam_role" "ws_api_gateway_role" {
  name = "${var.api_name}-WS-APIGatewayRole"
  tags = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [aws_iam_policy.ws_api_gateway_policy.arn]
}

resource "aws_apigatewayv2_api" "ws_api_gateway" {
  name                       = var.api_name
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
  tags                       = var.tags
}

resource "aws_apigatewayv2_integration" "ws_api_integration" {
  api_id                    = aws_apigatewayv2_api.ws_api_gateway.id
  integration_type          = "AWS_PROXY"
  integration_uri           = var.lambda_invoke_arn
  credentials_arn           = aws_iam_role.ws_api_gateway_role.arn
  content_handling_strategy = "CONVERT_TO_TEXT"
  passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_integration_response" "ws_api_integration_response" {
  api_id                   = aws_apigatewayv2_api.ws_api_gateway.id
  integration_id           = aws_apigatewayv2_integration.ws_api_integration.id
  integration_response_key = "/200/"
}

# Behaviour for default connection
resource "aws_apigatewayv2_route" "ws_api_default_route" {
  api_id    = aws_apigatewayv2_api.ws_api_gateway.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.ws_api_integration.id}"
}

resource "aws_apigatewayv2_route_response" "ws_api_default_route_response" {
  api_id             = aws_apigatewayv2_api.ws_api_gateway.id
  route_id           = aws_apigatewayv2_route.ws_api_default_route.id
  route_response_key = "$default"
}

# Behaviour for connect connection
resource "aws_apigatewayv2_route" "ws_api_connect_route" {
  api_id    = aws_apigatewayv2_api.ws_api_gateway.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.ws_api_integration.id}"
}

resource "aws_apigatewayv2_route_response" "ws_api_connect_route_response" {
  api_id             = aws_apigatewayv2_api.ws_api_gateway.id
  route_id           = aws_apigatewayv2_route.ws_api_connect_route.id
  route_response_key = "$default"
}

# Behaviour for disconnect connection
resource "aws_apigatewayv2_route" "ws_api_disconnect_route" {
  api_id    = aws_apigatewayv2_api.ws_api_gateway.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.ws_api_integration.id}"
}

resource "aws_apigatewayv2_route_response" "ws_api_disconnect_route_response" {
  api_id             = aws_apigatewayv2_api.ws_api_gateway.id
  route_id           = aws_apigatewayv2_route.ws_api_disconnect_route.id
  route_response_key = "$default"
}

resource "aws_apigatewayv2_stage" "ws_api_stage" {
  api_id      = aws_apigatewayv2_api.ws_api_gateway.id
  name        = var.stage
  auto_deploy = var.auto_deploy
}

resource "aws_lambda_permission" "ws_lambda_permissions" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.ws_api_gateway.execution_arn}/*/*"
}

resource "aws_iam_policy" "lambda_websocket_policy" {
  name = "${var.lambda_name}-websocket-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "execute-api:*",
        ],
        Effect = "Allow",
        Resource = [
          "${aws_apigatewayv2_api.ws_api_gateway.execution_arn}/*/*/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_websocket_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_websocket_policy.arn
  role       = var.lambda_role_name
}


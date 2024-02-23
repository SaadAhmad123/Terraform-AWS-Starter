output "websocket_gateway" {
  value = aws_apigatewayv2_api.ws_api_gateway
}

output "websocket_gateway_stage" {
  value = aws_apigatewayv2_stage.ws_api_stage
}

output "websocket_url" {
  value = "${aws_apigatewayv2_api.ws_api_gateway.api_endpoint}/${aws_apigatewayv2_stage.ws_api_stage.name}"
}

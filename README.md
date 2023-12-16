# AWS Terraform Project Starter

Welcome to the AWS Terraform Project Starter, a codebase that provides you with the terraform code needed to initiate your project on the AWS Cloud. This codebase includes a Terraform remote backend along with the primary Terraform code. 

To get started, follow the steps outlined below.

## Getting Started

### Prerequisites

- Ensure that you have Terraform installed in your local machine.
- Knowledge about AWS and Terraform is helpful.

### Setup Instructions

1. **Clone the Repository**

   Begin by cloning this repository into your local machine.

2. **Update .gitignore**

   Append `terraform.tfvars` to the `.gitignore` file.

3. **Update Project Name**

   Search for `{{project_name}}` across the project and replace it with `<YOUR_PROJECT_NAME>` of your choosing.

4. **Add Credentials**

   Navigate to `~/<project_dir>/terraform_remote_backend/terraform.tfvars` and add the required credentials. Repeat the process for `~/<project_dir>/terraform/terraform.tfvars`. For now, set `stage="dev"`. The other possible values are `np`, `prod` and `dev`.

5. **Initialize and Apply Terraform**

   Use the terminal to navigate to `~/<project_dir>/terraform_remote_backend`. Run the following commands:
   
   ```bash
   terraform init
   terraform apply
   ```

   Once the Terraform remote backend has been successfully applied, ensure to not change or update it again. If you need to change it, make sure you can migrate the remote backend. 

6. **Run the Shell Script**

   Navigate to `~/<project_dir>/terraform_remote_backend` and run the provided shell script with the following command:

   ```bash
   bash ./shell_tf_apply.sh
   ```

   This command will sync the environment remote backend, initialize Terraform, and run `terraform apply`.

Congratulations, your project is now ready to go!


### Enhanced Project Structure Explanation

The AWS Terraform Project Starter is structured to support multiple development stages, ensuring flexibility and scalability in your cloud infrastructure management. Here's a detailed guide on understanding and customizing the project structure:

#### Standard Branch Structure

1. **Default Branches**: Our project is pre-configured with three primary branches:
   - `dev` (Development)
   - `np` (Non-Production)
   - `prod` (Production, serves as the master branch)

   These branches are integral to the project's workflow, and it's advisable to retain their names for consistency.

2. **Adding New Environments**: To introduce additional environments:
   - Modify the `terraform_remote_backend.tf` file within the `./terraform_remote_backend` directory. Add your new environment name to the `environments` local variable:

     ```hcl
     locals {
       environments = ["dev", "np", "prod", "<new_environment>"]
     }
     ```

   - In the `./terraform/.backends` directory, create a file named `<new_environment>.tf.txt` and configure your Terraform backend settings as follows:

     ```hcl
     terraform {
      backend "s3" {
         bucket         = "{{project_name}}-terraform-state"
         key            = "<new_environment>/global/s3/terraform.tfstate"
         region         = "ap-southeast-2"
         dynamodb_table = "{{project_name}}-terraform-locks"
         encrypt        = true
       }
     }
     ```

   - Update the `stage` variable in `./terraform/terraform.tfvars` to your new environment name when you wish to deploy to this environment.

#### CI/CD Pipeline Integration

This start does not assume any CI/CD pipeline. However, two basic pipelines are provided for guidance and quick usage:

- **GitHub Workflows**: A sample GitHub Actions workflow is included in `./.github_ci_cd`. To activate this workflow, simply rename the directory to `./.github`.

- **GitLab CI/CD**: For GitLab users, the CI/CD configuration is available in `./.gitlab_ci_cd/.gitlab-ci.yml`. Copy this file to `./.gitlab-ci.yml` to enable the pipeline in your GitLab project.

These CI/CD configurations are designed to be flexible and easily adaptable to your specific requirements, ensuring a seamless integration into your existing development workflow.

### Environment setup for Git CI/CD 

In order to setup the Git CI/CD you can look inside the pipeline code and
provide the required variables to the git platfrom. These can be found in 
script `./.github_ci_cd/workflows/<env>.yml` (~ line 23 - name: Create temporary tfvars file).
For `./.gitlab_ci_cd/.gitlab-ci.yml`, these can be found in (~ line 13 - .prepare_template: &prepare).

### Additional Resources

Refer to the official [Terraform documentation](https://www.terraform.io/docs/index.html) and [AWS Documentation](https://aws.amazon.com/documentation/) for more information.

## Feedback

For any questions or feedback, please open an issue in the GitHub repository.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

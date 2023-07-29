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

### Project Structure

This project assumes the existence of three branches: `dev`, `np` (nonprod), and `prod` (the master branch). It is recommended not to alter these names. However, adding a new environment is straightforward. Extend the remote backend, then in `./terraform/.backends` configure the backend in the file `<environment_name>.tf.txt`.

While this project does not assume any CI/CD, a sample GitHub workflow is provided in `./.github_ci_cd`. This pipeline is ready to use and can be enabled by changing the name from `./.github_ci_cd` to `./.github`. In case of Gitlab, the CI/CD YAML is in `./.gitlab_ci_cd/.gitlab-ci.yml` copy it to `./.gitlab-ci.yml`. 

### Additional Resources

Refer to the official [Terraform documentation](https://www.terraform.io/docs/index.html) and [AWS Documentation](https://aws.amazon.com/documentation/) for more information.

## Feedback

For any questions or feedback, please open an issue in the GitHub repository.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

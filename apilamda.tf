resource "aws_api_gateway_rest_api" "Api_lamda_Example" {
  name        = "Api_lamda_Example"
  description = "Example of api contains lamda function"
}

resource "aws_api_gateway_resource" "Resource2" {
  rest_api_id = aws_api_gateway_rest_api.Api_lamda_Example.id
  parent_id   = aws_api_gateway_rest_api.Api_lamda_Example.root_resource_id
  path_part   = "Example_Api_lambda_post"
}


resource "aws_iam_role" "role_for_accessing_lambda"{
    name="role_lambda"
    description="creating role of lambda to access that lambda funtion in api"
    assume_role_policy=jsonencode({
        

    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:*"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::*"
        }
    ]

    })
 
}


resource "aws_lambda_function" "Example_lambda"{
    filename="./my-lambda-function.zip"
    function_name= "Api_lamda_function"
    runtime    ="python3.12"
    role          = aws_iam_role.role_for_accessing_lambda.arn
    handler       = "index.handler"
}

resource "aws_api_gateway_method" "Post_method" {
  rest_api_id   = aws_api_gateway_rest_api.Api_lamda_Example.id
  resource_id   = aws_api_gateway_resource.Resource2.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integrating_api_lambda"{
    rest_api_id             = aws_api_gateway_rest_api.Api_lamda_Example.id
    resource_id             = aws_api_gateway_resource.Resource2.id
    
    http_method             = aws_api_gateway_method.Post_method.http_method
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri=aws_lambda_function.Example_lambda.arn
}





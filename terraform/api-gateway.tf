resource "aws_apigatewayv2_api" "gitdog-example" {
  name          = "gitdog-example"
  protocol_type = "HTTP"
  cors_configuration {
    allow_headers = ["*"]
    allow_methods = ["*"]
    allow_origins = ["*"]
    max_age       = 300
  }
}

resource "aws_apigatewayv2_stage" "gitdog-example-lambda" {
  api_id      = aws_apigatewayv2_api.gitdog-example.id
  name        = "gitdog-example"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "gitdog-example-post" {
  api_id                 = aws_apigatewayv2_api.gitdog-example.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.gitdog_example.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "gitdog-example" {
  api_id    = aws_apigatewayv2_api.gitdog-example.id
  route_key = "GET /gitdog-example"
  target    = "integrations/${aws_apigatewayv2_integration.gitdog-example-post.id}"
}

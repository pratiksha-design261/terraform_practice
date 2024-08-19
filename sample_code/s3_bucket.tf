resource "aws_s3_bucket" "test_bucket" {

        bucket = "my-bucket-test-dev"
        tags = {
          Name = "my_bucket_tag"
          Environment = "dev"
        }
}

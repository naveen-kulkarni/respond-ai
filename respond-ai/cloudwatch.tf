resource "aws_cloudwatch_metric_alarm" "alarm_cpu" {
  alarm_name          = "alarm_cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    InstanceId = aws_instance.webserver.id
  }

  #alarm_actions = [aws_sns_topic.example_sns_topic.arn]
}

# Use S3 for File Storage:

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "s3-bucket"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.example_bucket.id}/*"
      ]
    }
  ]
}
EOF
}

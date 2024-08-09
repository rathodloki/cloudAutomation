output "public_ip" {
  value = aws_instance.web_server.public_ip
  description = "The public IP address of the web server instance."
}

output "dns_name" {
  value = aws_instance.web_server.public_dns 
  description = "The public DNS name of the web server instance (if available)."
}

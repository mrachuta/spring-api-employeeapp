output "ext_lb_ip_output_clickable_http" {
  value = module.gcp_webserver_lb.lb_ip_output_clickable_http
}

output "ext_lb_ip_output_clickable_https" {
  value = module.gcp_webserver_lb.lb_ip_output_clickable_https
}

output "employeeapp_image_output" {
  value = module.gcp_app_mig.mig_image_output
}

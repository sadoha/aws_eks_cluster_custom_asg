#
# Route 53 
#

resource "aws_route53_zone" "route53_zone" {
  name 				= var.domainname
  force_destroy 		= true

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

resource "aws_route53_record" "subdomains" {  
  count   		= "${length(var.subdomains)}"  
  zone_id 		= "${aws_route53_zone.route53_zone.zone_id}"  
  name    		= "${element(var.subdomains, count.index)}"  
  type    		= "CNAME"  
  records 		= [var.domainname]  
  ttl     		= "300"
}

resource "aws_route53_record" "route53_mx" {
  zone_id 		= aws_route53_zone.route53_zone.zone_id
  name   		= var.domainname
  type    		= "MX"
  ttl 			= "300"
  
  records 		= [
    			"1 ASPMX.L.GOOGLE.COM",
    			"5 ALT1.ASPMX.L.GOOGLE.COM",
    			"5 ALT2.ASPMX.L.GOOGLE.COM",
    			"10 ASPMX2.GOOGLEMAIL.COM",
    			"10 ASPMX3.GOOGLEMAIL.COM",  
  ]
}


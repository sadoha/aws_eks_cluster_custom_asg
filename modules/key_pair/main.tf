resource "aws_key_pair" "key_pair" {
  key_name      = "key-pair"
  public_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDR36YNwSadTNFjl3cXLYakzFqH9qgkEtGvRZEWo9RddXocvsW7uZrACI9XP/aY4F08aOTiNzfzqfjkzBVvNYR51nI8lKu/5YObPtNxAnz0UYy3MIH6NoC4c4S01z+6yTkNK6a6hxzgJWKI/ga0+652KPytzupUCjpJTx224oHwzMasMk+gCi2dPV5xWXXmOBFdx9IDXiVH56hbZx+EIP1MJh9PUxMkfzPGD2fXZ/7Ql9lbB+cS3AoJEW5zaH90HDNRYQQiGhIjJSAemS/SqgQnfDyJ35Ebsq4/vc3U4GZXHgGx0OOhfcz+p+lif+AOsa56Jz+mylyCk1Xu9d/FXoH1 andriisadovskyi@MacBook-Pro-zzz.local"

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

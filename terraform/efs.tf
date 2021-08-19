
resource "aws_efs_file_system" "jenkins" {
  creation_token = "jenkins"

  tags = {
    Name = "jenkins"
  }
}


resource "aws_efs_mount_target" "jenkins_mount_1" {
  file_system_id = aws_efs_file_system.jenkins.id
  subnet_id      = aws_subnet.ecs_subnet_1.id
  security_groups = [aws_security_group.efs.id]
  depends_on = [aws_efs_file_system.jenkins]
}


resource "aws_efs_mount_target" "jenkins_mount_2" {
  file_system_id = aws_efs_file_system.jenkins.id
  subnet_id      = aws_subnet.ecs_subnet_2.id
  security_groups = [aws_security_group.efs.id]
  depends_on = [aws_efs_file_system.jenkins]
}

resource "aws_efs_mount_target" "jenkins_mount_3" {
  file_system_id = aws_efs_file_system.jenkins.id
  subnet_id      = aws_subnet.ecs_subnet_3.id
  security_groups = [aws_security_group.efs.id]
  depends_on = [aws_efs_file_system.jenkins]
}


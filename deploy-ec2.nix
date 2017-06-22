let region = "eu-west-1";
    ec2 = { resources, ... }:
    { deployment.targetEnv = "ec2";
      deployment.ec2.region = region;
      deployment.ec2.ami = "ami-10754c76";
      deployment.ec2.instanceType = "t2.small";
      deployment.ec2.keyPair = resources.ec2KeyPairs.nixops-demo;
      deployment.ec2.securityGroups = [ "dbarlow-ssh" "default" ];
    };
in {
  resources.ec2KeyPairs.nixops-demo =
    { inherit region ; };

  webserver = ec2;
}

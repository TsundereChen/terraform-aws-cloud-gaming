import { Construct } from 'constructs';
import { App, TerraformStack, TerraformOutput } from 'cdktf';
import { AwsProvider,
    SpotFleetRequest } from './.gen/providers/aws';

class MyStack extends TerraformStack {
  constructor(scope: Construct, name: string) {
    super(scope, name);

    new AwsProvider(this, 'aws', {
        region: 'ap-northeast-1',
    });

    const spotRequest = new SpotFleetRequest(this, 'gaming-vm-spot-request', {
        iamFleetRole: "<IAM_ROLE>",
        targetCapacity: 1,
        waitForFulfillment: true,
        allocationStrategy: "lowestPrice",
        fleetType: "request",
        launchSpecification:[{
            ami: "ami-09b4882469bcc17c5",
            instanceType: "g4dn.xlarge",
            keyName: "<KEY_NAME>",
            vpcSecurityGroupIds:["<SECURITY_GROUP_ID>"],
            ebsOptimized: false,
        }]
    });

    new TerraformOutput(this, 'requestId', {
        value: spotRequest.id,
    });
  }
}

const app = new App();
new MyStack(app, 'cloud-gaming');
app.synth();

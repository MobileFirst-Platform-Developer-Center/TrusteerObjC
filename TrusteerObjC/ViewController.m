/**
* Copyright 2015 IBM Corp.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

#import "ViewController.h"
#import "TrusteerChallengeHandler.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *intro;
@property (weak, nonatomic) IBOutlet UILabel *result;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if([[WLTrusteer sharedInstance] hasTrusteerSDK]){
        self.intro.text = @"Trusteer SDK Found!";
        NSDictionary* risks = [[WLTrusteer sharedInstance] riskAssessment];
        NSNumber* rooted = [[risks objectForKey:@"os.rooted"] objectForKey:@"value"];
        if([rooted intValue] !=0 ){
            self.intro.text = [NSString stringWithFormat:@"%@ ... and it seems your device is jailbroken!", self.intro.text];
        }
        else{
            self.intro.text = [NSString stringWithFormat:@"%@ ... and it seems your device is NOT jailbroken!", self.intro.text];
        }
    }
}
- (IBAction)adapter:(id)sender {
    self.result.text = @"Invoking Procedure...";
    [[WLClient sharedInstance] registerChallengeHandler:[[TrusteerChallengeHandler alloc] initWithRealm:@"wl_basicTrusteerFraudDetectionRealm" andController:self]];
    
    NSURL* url = [NSURL URLWithString:@"/adapters/MyAdapter/getData"];
    WLResourceRequest* request = [WLResourceRequest requestWithURL:url method:WLHttpMethodGet];
    [request sendWithCompletionHandler:^(WLResponse *response, NSError *error) {
        if(error != nil){
            NSLog(@"Invocation Failure: %@", response);
            NSString *resultText = @"Invocation failure: ";
            
                resultText = [resultText stringByAppendingString:error.description];
                [self appendResult:resultText];
        }
        else{
            NSLog(@"Invocation Success: %@", response);
            NSString *resultText = @"Invocation success: ";
            
            if (response.responseJSON != nil){
                resultText = [resultText stringByAppendingString:response.responseJSON[@"data"]];
            }
            [self appendResult:resultText];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) appendResult:(NSString *)text {
    self.result.text = [NSString stringWithFormat:@"%@\n%@", self.result.text, text];
}

@end

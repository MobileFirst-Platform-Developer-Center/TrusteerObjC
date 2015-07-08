/**
 * COPYRIGHT LICENSE: This information contains sample code provided in source code form. You may copy, modify, and distribute
 * these sample programs in any form without payment to IBM® for the purposes of developing, using, marketing or distributing
 * application programs conforming to the application programming interface for the operating platform for which the sample code is written.
 * Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES,
 * EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY,
 * FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE.
 * IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
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

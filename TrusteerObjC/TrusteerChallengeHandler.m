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


#import "TrusteerChallengeHandler.h"
@interface TrusteerChallengeHandler()
@property ViewController* vc;
@end

@implementation TrusteerChallengeHandler
-(id)initWithRealm:(NSString *)iRealm andController:(ViewController *)vc {
    self = [super initWithRealm:iRealm];
    if(self){
        self.vc = vc;
    }
    return self;
}
-(void) handleFailure: (NSDictionary *)failure{
    NSLog(@"handleFailure");
    [self.vc appendResult:[NSString stringWithFormat:@"Your request could not be completed. Reason code: %@",failure[@"reason"]]];
}
-(void) handleSuccess:(NSDictionary *)success{
    NSArray* alerts = success[@"attributes"][@"alerts"];
    if(alerts && alerts.count){
        NSMutableString* result = [NSMutableString stringWithString:@"Please note that your device is: "];
        for(NSString* alert in alerts){
            [result appendString:alert];
            [result appendString:@" "];
        }
        [self.vc appendResult:result];
    }
}

@end

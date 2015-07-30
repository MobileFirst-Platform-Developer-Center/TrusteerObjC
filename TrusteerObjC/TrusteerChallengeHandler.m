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

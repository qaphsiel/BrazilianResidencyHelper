	//
//  BraResHelSecondViewController.m
//  Brazilian Residency Helper
//
//  Created by Cary on 2/21/13.
//  Copyright (c) 2013 Ratatosk. All rights reserved.
//

#import "BraResHelSecondViewController.h"
#import "QueryDou.h"

@interface BraResHelSecondViewController ()

@property (nonatomic, strong) QueryDou *dou;
@property (nonatomic, strong) NSArray *htmlResults;
@property (nonatomic, strong) NSString *queryString;
@property (weak, nonatomic) IBOutlet UITextField *queryStringField;
@property (weak, nonatomic) IBOutlet UIWebView *resultsView;

@end

@implementation BraResHelSecondViewController

-(QueryDou *)dou
{
    if (!_dou) {
        NSLog(@"Init dou");
        _dou = [[QueryDou alloc] init];
    }
    return _dou;
}


- (IBAction)checkDOUButton:(id)sender {
    NSLog(@"button clicked");
    if (self.queryStringField.text)
    {
        [self.queryStringField resignFirstResponder];
        NSString *qs = [QueryDou scrubText:self.queryStringField.text];
        NSLog(@"field has text '%@'", qs);
        self.dou = [[QueryDou alloc] init];
        [self.dou parseDOUData:[self.dou getDOUData:qs]];
        self.dou.htmlString = nil;
        NSString *stringified = [self.dou stringifyNode:self.dou.htmlResults[0] stringToAppendTo:@""];
        NSLog(@"stringified %@", stringified);
        [self.resultsView loadHTMLString:stringified baseURL:nil];
        for (NSObject *item in self.htmlResults)
        {
            NSLog(@"item.desc %@", item.description);
        }
    }

}


- (IBAction)daysAgoSelector:(id)sender {
    
    int daysAgo = [[sender titleForSegmentAtIndex:[sender selectedSegmentIndex]] intValue];
}


- (IBAction)queryStringLabel:(id)sender {
    NSLog(@"return hit");
    [self checkDOUButton:(id)sender];

}


-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.queryStringField resignFirstResponder];
    return NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.resultsView.delegate = self;
    self.queryStringField.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

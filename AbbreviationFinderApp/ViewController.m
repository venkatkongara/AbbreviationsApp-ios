//
//  ViewController.m
//  AbbreviationFinderApp
//
//  Created by siva kongara on 10/2/15.
//  Copyright © 2015 siva kongara. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *input;

@property (weak, nonatomic) IBOutlet UILabel *searchedFromWeb;
@property (weak,nonatomic) NSArray * responseObjectDictionary;
@property (weak,nonatomic) MBProgressHUD *hud;

- (IBAction)searchButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *setButtonPropertiesOutlet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
    self.setButtonPropertiesOutlet.backgroundColor = [UIColor blueColor];
    self.input.placeholder = @"Enter input here";
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeAnnularDeterminate;
    self.hud.labelText = @"downloading";
    [self.hud hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButtonTapped:(id)sender {
    
    [self.hud show:YES];
    
    NSDictionary *parameters = @{@"format": @"json",@"sf":self.input.text};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"http://www.nactem.ac.uk/software/acromine/dictionary.py" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.responseObjectDictionary = (NSArray *)responseObject;
        NSMutableString* mutString = [[NSMutableString alloc] init];
        
        if(responseObject){
            NSLog(@"%@",responseObject);
        for(int i =0;i<[[responseObject[0] objectForKey:@"lfs"] count];i++){
            [mutString appendString:@"\n"];
            [mutString appendString:[([responseObject[0] objectForKey:@"lfs"][i]) objectForKey:@"lf"]];
        }
        }
        else{
        
            self.searchedFromWeb.text = @"No such abbreviation found!";
        }
        
        self.searchedFromWeb.text = mutString;
        
        [self.hud hide:YES];
        //[self.view reloadInputViews];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
@end

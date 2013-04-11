//
//  ShopMenuViewController.m
//  Icon-Blitz
//
//  Created by Danny on 4/8/13.
//
//

#import "ShopMenuViewController.h"
#import "ShopItemsCell.h"

@interface ShopMenuViewController ()

@end

@implementation ShopMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)closeView:(id)sender {
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  self.shopCell = nil;
  self.shopTableView = nil;
  [self.shopCell release];
  [self.shopTableView release];
  [super dealloc];
}

#pragma mark TableView Delegates Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"ShopItems";
  
  ShopItemsCell *cell = (ShopItemsCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (cell == nil) {
    [[NSBundle mainBundle] loadNibNamed:@"ShopItemsCell" owner:self options:nil];
    cell = self.shopCell;
  }
  return cell;
}


@end

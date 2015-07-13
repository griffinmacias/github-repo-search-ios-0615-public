//
//  FISReposTableViewController.m
//  
//
//  Created by Joe Burgess on 5/5/14.
//
//

#import "FISReposTableViewController.h"
#import "FISReposDataStore.h"
#import "FISGithubRepository.h"
#import "FISGithubAPIClient.h"

@interface FISReposTableViewController ()
@property (strong, nonatomic) FISReposDataStore *dataStore;
- (IBAction)searchButtonTapped:(id)sender;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) UIAlertController *searchAlertController;
- (IBAction)allReposTapped:(id)sender;
@property (nonatomic, strong) NSString *keyWord;
@end

@implementation FISReposTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.accessibilityLabel=@"Repo Table View";
    self.tableView.accessibilityIdentifier=@"Repo Table View";

    self.tableView.accessibilityIdentifier = @"Repo Table View";
    self.tableView.accessibilityLabel=@"Repo Table View";
    self.dataStore = [FISReposDataStore sharedDataStore];

    [self.dataStore getRepositoriesWithCompletion:^(BOOL success) {
        [self.tableView reloadData];
        
        
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataStore.repositories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell" forIndexPath:indexPath];

    FISGithubRepository *repo = self.dataStore.repositories[indexPath.row];
    cell.textLabel.text = repo.fullName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *unStarredMessage = @"This repository is unstarred";
    NSString *starMessage = @"This repository is starred.";
        FISGithubRepository *repo = self.dataStore.repositories[indexPath.row];
    [FISGithubAPIClient toggleStarForRepository:repo.fullName completion:^(BOOL success) {
        if (success) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.alertController.message = starMessage;
                [self presentViewController:self.alertController animated:YES completion:nil];
            }];

           

        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                self.alertController.message = unStarredMessage;
                [self presentViewController:self.alertController animated:YES completion:nil];
            }];

        }
        NSLog(@"%d",success);
    }];
}

- (IBAction)searchButtonTapped:(id)sender
{
    
    
    self.alertController = [UIAlertController
                            alertControllerWithTitle:@"Info"
                            message:@"Hi"
                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                                   UITextField *text = self.searchAlertController.textFields.firstObject;
                                   NSLog(@"%@",text.text);
                                   [self.dataStore searchRepositoriesWithCompletion:text.text completionBlock:^(BOOL success) {
                                       NSLog(@"%@",self.dataStore.repositories);
                                       [self.tableView reloadData];
                                   }];
                                   
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    
    self.searchAlertController = [UIAlertController
                                  alertControllerWithTitle:@"Search"
                                  message:@"Repository"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [self.searchAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"LoginPlaceholder", @"Login");
         
     }];
    
    
    [self.alertController addAction:okAction];
    [self.searchAlertController addAction:okAction];
    [self.searchAlertController addAction:cancelAction];
    
    [self presentViewController:self.searchAlertController animated:YES completion:nil];
}


- (IBAction)allReposTapped:(id)sender {
    [self.dataStore.repositories removeAllObjects];
    [self.dataStore getRepositoriesWithCompletion:^(BOOL success) {
        [self.tableView reloadData];
        
        
    }];

}
@end

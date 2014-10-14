#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Article.h"

@interface MasterViewController ()

@property NSMutableArray *_articles;

@end

@implementation MasterViewController

NSString *const kUrl = @"http://crazy-dev.wheely.com";

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self._articles = [[NSMutableArray alloc] init];

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
	[self.navigationItem setRightBarButtonItem:addButton animated:YES];
	
	[NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
	[self refresh:nil];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)refresh:(id)sender {
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kUrl]];
	[NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"showDetail"]) {
	    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	    Article *art = self._articles[indexPath.row];
	    [[segue destinationViewController] setDetailItem:art];
	}
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self._articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

	Article *art = self._articles[indexPath.row];
	cell.textLabel.text = [art title];
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
	    [self._articles removeObjectAtIndex:indexPath.row];
	    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

#pragma mark - Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	_responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSError *error;
	NSArray *response = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&error];
	
	[self._articles removeAllObjects];
	
	for (NSDictionary * item in response) {
		Article * art = [[Article alloc] init];
		art.title = [item valueForKey:@"title"];
		art.text = [item valueForKey:@"text"];
		[self._articles addObject:art];
		[self.tableView reloadData];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"%@", [error localizedDescription]);
}

@end

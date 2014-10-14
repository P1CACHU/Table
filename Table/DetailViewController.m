#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
	if (_detailItem != newDetailItem) {
	    _detailItem = newDetailItem;
		
	    [self configureView];
	}
}

- (void)configureView {
	if (self.detailItem) {
	    self.detailedText.text = [self.detailItem text];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self configureView];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end

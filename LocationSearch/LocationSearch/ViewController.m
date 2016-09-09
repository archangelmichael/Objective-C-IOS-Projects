//
//  ViewController.m
//  LocationSearch
//
//  Created by Radi on 9/9/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnClear;
@property (weak, nonatomic) IBOutlet UITableView *tvSuggestions;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cstrTableHeight;

@end

@implementation ViewController {
    NSMutableArray <MKPlacemark *> * locations;
    CGFloat defaultRowHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup search field
    self.tfSearch.delegate = self;
    self.tfSearch.autocorrectionType = UITextAutocorrectionTypeNo;
    self.tfSearch.spellCheckingType = UITextSpellCheckingTypeNo;

    // Setup table view
    self.tvSuggestions.dataSource = self;
    self.tvSuggestions.delegate = self;
    self.tvSuggestions.hidden = true;
    self.tvSuggestions.showsHorizontalScrollIndicator = false;
    self.tvSuggestions.allowsSelection = true;
    
    defaultRowHeight = 30;
    
    // Setup suggestions
    locations = [NSMutableArray array];
    
    UITapGestureRecognizer * screenTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(screenTap)];
    [self.mapView addGestureRecognizer:screenTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClear:(id)sender {
    self.tfSearch.text = @"";
    [self setTableVisibility:false];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultsCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"DefaultCell"];
    }
    
    defaultRowHeight = cell.frame.size.height;
    
    NSInteger row = indexPath.row;
    if (row < 0 || row >= locations.count) {
        return cell;
    }
    
    MKPlacemark * placemark = locations[row];
    NSArray *lines = placemark.addressDictionary[@"FormattedAddressLines"];
    NSString *addressString = [lines componentsJoinedByString:@", "];
    cell.textLabel.text = addressString;
    return cell;
}

#pragma mark - TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    MKPlacemark * placemark = locations[indexPath.row];
    [locations removeAllObjects];
    [self screenTap];
    [self.mapView setCenterCoordinate:placemark.coordinate animated:false];
}

#pragma mark - TableView methods
- (void)setTableVisibility:(BOOL)visible {
    if (visible) {
        self.tvSuggestions.alpha = 0.0;
        self.tvSuggestions.hidden = false;
        self.cstrTableHeight.constant = [self getTableHeight];
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.tvSuggestions.alpha = 1.0;
                             [self.tvSuggestions layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    else {
        self.tvSuggestions.hidden = true;
        self.cstrTableHeight.constant = 0;
        [self.tvSuggestions layoutIfNeeded];
    }
}

- (CGFloat)getTableHeight {
    CGFloat suggestionsHeight = locations.count * defaultRowHeight;
    return suggestionsHeight > 300 ? 300 : suggestionsHeight;
}

#pragma mark - UITextFieldDelegate
- (void)screenTap {
    [self.tfSearch resignFirstResponder];
    [locations removeAllObjects];
    [self setTableVisibility:false];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *searchInput = [NSString stringWithString:textField.text];
    searchInput = [searchInput stringByReplacingCharactersInRange:range
                                                       withString:string];
    [self searchForLocationBy:searchInput];
    return true;
}

- (void)searchForLocationBy:(NSString *)search {
//     [self performGeocoderSearchBy:search];
    [self performMapViewSearchBy:search];
}

- (void)performMapViewSearchBy:(NSString *)search {
    MKLocalSearchRequest * mapRequest = [[MKLocalSearchRequest alloc] init];
    mapRequest.naturalLanguageQuery = search;
    // mapRequest.region = self.mapView.region;
    MKLocalSearch * localSearch = [[MKLocalSearch alloc] initWithRequest:mapRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response,
                                              NSError * _Nullable error) {
        [locations removeAllObjects];
        if (error != nil || response == nil) {
            [self setTableVisibility:false];
            return;
        }
        
        NSArray * mapItems = response.mapItems;
        for (MKMapItem * mapItem in mapItems) {
            [locations addObject:mapItem.placemark];
        }
        
        if (locations.count > 0) {
            [self setTableVisibility:true];
            [self.tvSuggestions reloadData];
        }
        else {
            [self setTableVisibility:false];
        }
    }];
};

- (void)performGeocoderSearchBy:(NSString *)search {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:search
                 completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error != nil) {
             [self setTableVisibility:false];
             [locations removeAllObjects];
             return;
         }
         
         if (placemarks.count > 0) {
             for (CLPlacemark *placemark in placemarks) {
                 NSArray *lines = placemark.addressDictionary[@"FormattedAddressLines"];
                 NSString *addressString = [lines componentsJoinedByString:@", "];
                 NSLog(@"Address: %@", addressString);
             }
         }
     }];
}

@end

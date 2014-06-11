//
//  APHomeViewController.m
//  AlePlace
//
//  Created by Apple on 6/5/14.
//
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestKivaLoansURL [NSURL URLWithString: @"http://cms.aleplace.com/ws/api/events/getData?esapikey=5d7299e5d3ea2698b9ef43527eae374e1ce439da&format=json"]
#import "APHomeViewController.h"
#import "APCallAPI.h"
#import "APParserData.h"
#import "APEvent.h"
#import "APEventTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "APDetailEventViewController.h"
#import "FMConstants.h"
#import "APMoreViewController.h"
#import "FMUtils.h"
#import "APEventCellTableViewCell.h"

@interface APHomeViewController ()
{
    NSMutableArray *listEvents;
    BOOL flagMore;
}
@end

@implementation APHomeViewController
@synthesize tableViewEvent,imageViewStart,imageViewRound;
@synthesize customCell = _customCell;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    flagMore = FALSE;
    imageViewStart.hidden = YES;
    imageViewRound.hidden = YES;
    listEvents = [[NSMutableArray alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self callAPIGetEvents];
    [self.tableViewEvent setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    dispatch_async(kBgQueue, ^{
//        NSData* data = [NSData dataWithContentsOfURL: kLatestKivaLoansURL];
//        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
//    });
//    
    // Do any additional setup after loading the view from its nib.
    [self.tableViewEvent registerNib:[UINib nibWithNibName:@"APEventTableViewCell" bundle:nil] forCellReuseIdentifier:@"APEventTableViewCell"];
    [self.tableViewEvent registerNib:[UINib nibWithNibName:@"APEventCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"APEventCellTableViewCell"];
    
    self.tableViewEvent.scrollEnabled = NO;
    
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"testView" owner:self options:nil];
    
     UIView *view = [[UIView alloc] init]; // or if it exists, MCQView *view = [[MCQView alloc] init];
     view = (UIView *)[nib objectAtIndex:0]; // or if it exists, (MCQView *)[nib objectAtIndex:0];
     [self.navigationController.navigationBar addSubview:view];
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"ALEPLAGE";
    listEvents = [[NSMutableArray alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self callAPIGetEvents];
    [self.tableViewEvent setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    /*dispatch_async(kBgQueue, ^{
     NSData* data = [NSData dataWithContentsOfURL: kLatestKivaLoansURL];
     [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
     });*/
    
    // Do any additional setup after loading the view from its nib.
}
-(void)callAPIGetEvents{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@"json" forKey:@"format"];
    [dictionary setValue:@"5d7299e5d3ea2698b9ef43527eae374e1ce439da" forKey:@"esapikey"];
    [APCallAPI getEvents:^(NSArray *listEvent, NSObject *error) {
        listEvents = [NSMutableArray arrayWithArray:listEvent];
        [self.tableViewEvent reloadData];
        imageViewStart.hidden = NO;
        imageViewRound.hidden = NO;
    } parameters:dictionary didFail:^(NSObject *error) {
    }];
    
}
- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                         options:kNilOptions
                                                           error:&error];
    [APParserData parseJSONtoArrayOfProduct:json];
   
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [listEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"APEventTableViewCell";
        //    APEventTableViewCell *cell = nil;
        APEventTableViewCell *cell = (APEventTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[APEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            [[NSBundle mainBundle] loadNibNamed:@"APEventTableViewCell" owner:self options:nil];
            
        }
        APEvent *event = [listEvents objectAtIndex:indexPath.row];
        cell.nameEvent.text = event.nameEvent;
        cell.dateEvent.text = [NSString stringWithFormat:@"%@-%@",event.start_dateEvent,event.end_dateEvent];
        [cell.imageEvent setImageWithURL:[NSURL URLWithString:event.thumb_photoEvent] placeholderImage:nil];
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"APEventCellTableViewCell";
        //    APEventTableViewCell *cell = nil;
        APEventCellTableViewCell *cell = (APEventCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[APEventCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            [[NSBundle mainBundle] loadNibNamed:@"APEventCellTableViewCell" owner:self options:nil];
            
        }
        APEvent *event = [listEvents objectAtIndex:indexPath.row];
        cell.nameEvent.text = event.nameEvent;
        cell.dateEvent.text = [NSString stringWithFormat:@"%@-%@",event.start_dateEvent,event.end_dateEvent];
        [cell.imageEvent setImageWithURL:[NSURL URLWithString:event.thumb_photoEvent] placeholderImage:nil];
        
        return cell;

    }
    //    if (cell == nil) {
//       // cell = [[APEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"APEventTableViewCell" owner:self options:nil];
//        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
//        /*for( id obj in topLevelObjects ) {
//            if( [obj isMemberOfClass:[APEventTableViewCell class] ]  || [obj isKindOfClass:[APEventTableViewCell class]] ) {
//                cell = obj;
//            }
//        }*/
//       
//
//        APEventTableViewCell* temp = [topLevelObjects objectAtIndex:0];
//        
//       
//        cell =temp;
//    }
}


//- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
//    // get the imageView that was tapped
//    UIImageView *imageView = gestureRecognizer.view;
//    imageView.image = [UIImage imageNamed:NSLocalizedString(@"button_continue",@"")];
//    // do something else
//}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    APEvent *event = [listEvents objectAtIndex:indexPath.row];
    APDetailEventViewController *detailEventViewController = [[APDetailEventViewController alloc] initWithNibName:@"APDetailEventViewController" bundle:nil];
    detailEventViewController.idEvent = event.eventID;
    [self.navigationController pushViewController:detailEventViewController animated:NO];
}

- (IBAction)backBtnClick:(id)sender {
    if (flagMore) {
        flagMore = FALSE;
        [[NSNotificationCenter defaultCenter]postNotificationName:kRevovemore object:self];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:ktest object:self userInfo:@{kNameView:@"APStadiumViewController"}];
    }
}
- (IBAction)more:(id)sender{
    if (!flagMore) {
        flagMore = TRUE;
        APMoreViewController *moreView = [[APMoreViewController alloc] initWithNibName:@"APMoreViewController" bundle:nil];
        [self.navigationController pushViewController:moreView animated:NO];
    }
}
@end

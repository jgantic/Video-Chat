//
//    Copyright (c) 2015 Shyam Bhat
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "IKCollectionViewController.h"
#import "IKCell.h"
//#import "InstagramMedia.h"
#import "IKMediaViewController.h"
#import "Constants.h"


#define kNumberOfCellsInARow 3
#define kFetchItemsCount 9

@interface IKCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *mediaArray;
@property (nonatomic) CGFloat offset;
//@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
//@property (nonatomic, weak) InstagramEngine *instagramEngine;

@end


@implementation IKCollectionViewController


- (void)viewDidLoad
{
    
    
  
    [super viewDidLoad];

    
    [self.navigationController setNavigationBarHidden:YES];
    self.mediaArray = [[NSMutableArray alloc] init];
    self.offset = 0.0f;
    //self.instagramEngine = [InstagramEngine sharedEngine];
    [self updateCollectionViewLayout];
    
    [self loadMedia];
 
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}


/**
 *  Depending on whether the Instagram session is authenticated,
 *  this method loads either the publicly accessible popular media
 *  or the authenticated user's feed.
 */
- (void)loadMedia
{
    //self.currentPaginationInfo = nil;
    [self setTitle:@"Popular Media"];
    [self.navigationItem.leftBarButtonItem setTitle:@"Log in"];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.mediaArray removeAllObjects];
    [self.collectionView reloadData];
    [self requestPopularMedia];
}


#pragma mark - API Requests -

/**
    - requestPopularMedia
    Calls InstagramKit's Helper method to fetch Popular Instagram Media.
 */
- (void)requestPopularMedia
{
    
    /*[self.instagramEngine getMediaForUser:@"20282699" count:kFetchItemsCount maxId:self.currentPaginationInfo.nextMaxId withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        
        self.currentPaginationInfo = paginationInfo;
        
        [self.mediaArray addObjectsFromArray:media];
        [self.collectionView reloadData];
        
        if (_offset!=0) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.mediaArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        }
        
    }
        failure:^(NSError *error, NSInteger statusCode) {
            NSLog(@"Request Self Feed Failed");
    }];*/

}


#pragma mark - UIStoryboardSegue -


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue.media.detail"]) {
        IKMediaViewController *mediaViewController = (IKMediaViewController *)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathsForSelectedItems][0];
       
    }
}

-(IBAction)unwindSegue:(UIStoryboardSegue *)sender
{
    [sender.sourceViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource Methods -


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mediaArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IKCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CPCELL" forIndexPath:indexPath];
    InstagramMedia *media = self.mediaArray[indexPath.row];
    
    CGFloat size = (self.view.bounds.size.width/ kNumberOfCellsInARow);
    
    NSLog(@"size %f", self.view.bounds.size.width);
    
    cell.imageView.frame= CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, size, size);
    
    //[cell setImageUrl:media.thumbnailURL];
    return cell;
}


- (void)updateCollectionViewLayout
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat size = floor(((self.view.bounds.size.width*45)/100)/ kNumberOfCellsInARow)-5;
    
    layout.itemSize = CGSizeMake(size, size);
}

#pragma UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    // Calculate where the collection view should be at the right-hand end item
    float contentOffsetWhenFullyScrolledRight = self.collectionView.frame.size.width * ([self.mediaArray count] -1);
    
    if (scrollview.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
        // user is scrolling to the right from the last item to the 'fake' item 1.
        // reposition offset to show the 'real' item 1 at the left-hand end of the collection view
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
    } else if (scrollview.contentOffset.x == 0)  {
        
        // user is scrolling to the left from the first item to the fake 'item N'.
        // reposition offset to show the 'real' item N at the right end end of the collection view
        
        if ((self.offset==0.0f) || (self.offset<scrollview.contentOffset.y)) {
            self.offset = scrollview.contentOffset.y;
            [self requestPopularMedia];
        }
    }
}


@end

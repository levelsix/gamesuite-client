//
//  HomeViewController.h
//  Icon-Blitz
//
//  Created by Danny on 3/20/13.
//
//

#import <UIKit/UIKit.h>

typedef enum {
  kNewGame = 0,
  kYourTurn,
  kTheirTurn,
  kOtherStuff
}SectionTypes;

@class StartGameCell;
@class TurnCells;

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet StartGameCell *startCell;
@property (nonatomic, retain) IBOutlet TurnCells *turnCell;
@property (nonatomic, retain) NSArray *turns;

@end

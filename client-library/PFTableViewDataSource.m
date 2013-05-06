//
//  PFTableViewDataSource.m
//  Percero
//
//  Created by Jeff Wolski on 4/30/13.
//
//

#import "PFTableViewDataSource.h"
#import "PFBindingTableViewCell.h"

@interface PFTableViewDataSource ()

@property (nonatomic, strong) NSMutableArray *rowBindings;

@end


@implementation PFTableViewDataSource

- (NSArray *) tableView:(UITableView *)tableView rowsArrayForSection:(NSInteger)section{
    NSArray *cellsArray;
    if (_keyPathForCellsArray) {
        NSArray *sectionsArray = [_anchorObject valueForKeyPath:_keyPathForSectionsArray];
        id sectionObject = sectionsArray[section];
        cellsArray = [sectionObject valueForKeyPath:_keyPathForCellsArray];
        
    } else {
        cellsArray = [_anchorObject valueForKeyPath:_keyPathForCellsArray];
    }
    return cellsArray;
}

- (void)setPfBindingTableViewCellSubclass:(Class)pfBindingTableViewCellSubclass{
    if ([pfBindingTableViewCellSubclass isSubclassOfClass:[PFBindingTableViewCell class]]) {
        _pfBindingTableViewCellSubclass = pfBindingTableViewCellSubclass;
    } else {
        [NSException exceptionWithName:@"PFTableViewDataSource" reason:@"pfBindingTableViewCellSubclass myst be a subclass of PFBindingTableViewCell" userInfo:@{@"pfBindingTableViewCellSubclass":pfBindingTableViewCellSubclass}];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *cellsArray;
    
    cellsArray = [self tableView:tableView rowsArrayForSection:indexPath.section];
        
    id cellObject = cellsArray[indexPath.row];

    PFBindingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[_pfBindingTableViewCellSubclass class]description]];
    if (!cell) {
        if (self.pfBindingTableViewCellSubclass == [PFBindingTableViewCell class]) {
            cell = [[_pfBindingTableViewCellSubclass alloc] initWithkeyPathForAnchorObjectLabelString:self.keyPathForCellLabelText];

        } else {
            cell = [[_pfBindingTableViewCellSubclass alloc] initWithDataObject:cellObject];
        }
        
        if (!cell.textLabel.text) cell.textLabel.text = @".";

    }
    
    cell.dataObject = cellObject;
    

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (!_keyPathForSectionsArray) {
        return nil;
    }
    
    NSArray *sectionsArray = [_anchorObject valueForKeyPath:_keyPathForSectionsArray];
    id sectionObject = sectionsArray[section];
    NSString *sectionTitle = [sectionObject valueForKeyPath:_keyPathForSectionLabelText];
    return sectionTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    NSArray *cellsArray;
    
    cellsArray = [self tableView:tableView rowsArrayForSection:section];

    NSInteger numberOfCells = cellsArray.count;
    return numberOfCells;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger numberOfSections = 1;
    if (_keyPathForSectionsArray) {
        NSArray *sectionsArray = [_anchorObject valueForKeyPath:_keyPathForSectionsArray];
        numberOfSections = sectionsArray.count;

    }
    return numberOfSections;
}
#pragma mark

- (id)init{
    if (self = [super init]);{

    }
    return self;
}

- (id) initWithAnchorObject:(id)anchorObject
pfBindingTableViewCellSubclass: (Class) pfBindingTableViewCellSubclass
    keyPathForSectionsArray:(NSString *)keyPathForSectionsArray
       keyPathForCellsArray:(NSString *)keyPathForCellsArray
 keyPathForSectionLabelText:(NSString *)keyPathForSectionLabelText
    keyPathForCellLabelText:(NSString *)keyPathForCellLabelText
                sectionMode:(PFTableViewDataSourceMode)sectionMode{
    if (self = [self init]) {
        _anchorObject = anchorObject;
        _pfBindingTableViewCellSubclass = pfBindingTableViewCellSubclass;
        if (!_pfBindingTableViewCellSubclass){ _pfBindingTableViewCellSubclass = [PFBindingTableViewCell class];
        }
        _keyPathForSectionsArray = keyPathForSectionsArray;
        _keyPathForCellsArray = keyPathForCellsArray;
        _keyPathForSectionLabelText = keyPathForSectionLabelText;
        _keyPathForCellLabelText = keyPathForCellLabelText;
        
        
    }
    
    return self;
}

+ (PFTableViewDataSource *)TableSectionDataWithAnchorObject:(id)anchorObject pfBindingTableViewCellSubclass:(Class)pfBindingTableViewCellSubclass keyPathForSectionsArray:(NSString *)keyPathForSectionsArray keyPathForCellsArray:(NSString *)keyPathForCellsArray keyPathForSectionLabelText:(NSString *)keyPathForSectionLabelText keyPathForCellLabelText:(NSString *)keyPathForCellLabelText sectionMode:(PFTableViewDataSourceMode)sectionMode {
    
    PFTableViewDataSource *result = [[PFTableViewDataSource alloc] initWithAnchorObject:anchorObject pfBindingTableViewCellSubclass:pfBindingTableViewCellSubclass keyPathForSectionsArray:keyPathForSectionsArray keyPathForCellsArray:keyPathForCellsArray keyPathForSectionLabelText:keyPathForSectionLabelText keyPathForCellLabelText:keyPathForCellLabelText sectionMode:sectionMode];
    return result;
}
- (void)setAnchorObject:(id)anchorObject{
    _anchorObject = anchorObject;
    
}
@end

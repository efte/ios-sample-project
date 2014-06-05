//
//  EFTEDebugTableViewController.m
//  efet-iOS
//
//  Created by Maxwin on 14-6-5.
//  Copyright (c) 2014年 大众点评. All rights reserved.
//

#import "EFTEDebugTableViewController.h"

#define USERDEFAULT_SELECT_PATH @"efte_debug_prefix_path"
#define USERDEFAULT_SAVED_PATHS @"efte_debug_prefix_paths"

typedef enum {
    SectionTypeAddPath,
    SectionTypePaths
}SectionType;

@interface EFTEDebugTableViewController ()
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSMutableArray *paths;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellForAddPath;
@property (strong, nonatomic) IBOutlet UITextView *textViewForPath;

@property (strong, nonatomic) NSString *selectedPath;
@end

@implementation EFTEDebugTableViewController

+ (NSString *)prefixPath
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_SELECT_PATH];
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.selectedPath = [[self class] prefixPath];
        [self loadPaths];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Debug Config";
    self.sections = @[@(SectionTypeAddPath), @(SectionTypePaths)];
}

- (IBAction)onAddButtonClick:(id)sender
{
    [self addPath:self.textViewForPath.text];
    [self.textViewForPath resignFirstResponder];
}

- (void)addPath:(NSString *)path
{
    if (path.length == 0) return;
    
    [self.paths removeObject:path];
    [self.paths insertObject:path atIndex:0];
    
    self.selectedPath = path;
    [self.tableView reloadData];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.paths forKey:USERDEFAULT_SAVED_PATHS];
}

- (void)loadPaths
{
    NSArray *paths = [[NSUserDefaults standardUserDefaults] arrayForKey:USERDEFAULT_SAVED_PATHS];
    if (paths) {
        self.paths = [paths mutableCopy];
    } else {
        self.paths = [NSMutableArray new];
    }
}

- (void)setSelectedPath:(NSString *)selectedPath
{
    _selectedPath = selectedPath;
    [[NSUserDefaults standardUserDefaults] setObject:selectedPath forKey:USERDEFAULT_SELECT_PATH];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionType sectionType = [self.sections[section] intValue];
    if (sectionType == SectionTypeAddPath) {
        return 1;
    }
    return self.paths.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SectionType sectionType = [self.sections[section] intValue];
    if (sectionType == SectionTypeAddPath) {
        return @"新增调试页面root路径";
    }
    return @"选择已有路径";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionType sectionType = [self.sections[indexPath.section] intValue];
    if (sectionType == SectionTypeAddPath) {
        return self.cellForAddPath.frame.size.height;
    }
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionType sectionType = [self.sections[indexPath.section] intValue];
    if (sectionType == SectionTypeAddPath) {
        self.cellForAddPath.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.cellForAddPath;
    }
    
    
    static NSString *CELLID = @"cellpath";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    NSString *path = self.paths[indexPath.row];
    cell.textLabel.text = path;
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([path isEqualToString:self.selectedPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionType sectionType = [self.sections[indexPath.section] intValue];
    if (sectionType == SectionTypePaths) {
        self.selectedPath = self.paths[indexPath.row];
        [self.tableView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.textViewForPath resignFirstResponder];
}


@end

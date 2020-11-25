//
//  ViewController.m
//  AllFontList
//
//  Created by cheng on 2020/11/25.
//

#import "ViewController.h"

@interface ViewController ()
<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UITextField *_textField;
    
    UITextView *_fontTextField;
    
    UITableView *_tableView;
    
    NSMutableArray *_allFontList;
    NSMutableArray *_fontFamilies;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _allFontList = [NSMutableArray array];
    _fontFamilies = [NSMutableArray array];
    
    NSArray *families = [UIFont familyNames];
    families = [families sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    for (NSString *fam in families) {
        NSArray *fonts = [UIFont fontNamesForFamilyName:fam];
        if (fonts.count) {
            [_allFontList addObject:fonts];
            [_fontFamilies addObject:fam];
        }
    }
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, width - 40, 50)];
    _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textField.delegate = self;
    _textField.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.f];
    _textField.text = @"ABCDEFG abcdefg 0123456789 ——";
    _textField.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_textField];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 130)];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];
    
    _fontTextField = [[UITextView alloc] initWithFrame:CGRectMake(20, height - 60, width - 40, 50)];
    _fontTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _fontTextField.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.f];
    _fontTextField.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_fontTextField];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allFontList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [_allFontList objectAtIndex:section];
    return array.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_fontFamilies objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 26;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.textLabel.numberOfLines = 0;
    }
    cell.textLabel.text = _textField.text;
    NSArray *array = [_allFontList objectAtIndex:indexPath.section];
    NSString *font = [array objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:font size:16];
    
    cell.detailTextLabel.text = font;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_textField resignFirstResponder];
    [_fontTextField resignFirstResponder];
    
    NSArray *array = [_allFontList objectAtIndex:indexPath.section];
    NSString *font = [array objectAtIndex:indexPath.row];
    NSString *result = [NSString stringWithFormat:@"[UIFont fontWithName:@\"%@\" size:16];", font];
    _fontTextField.text = result;
    [UIPasteboard generalPasteboard].string = result;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_tableView reloadData];
    [textField resignFirstResponder];
    return YES;
}

@end

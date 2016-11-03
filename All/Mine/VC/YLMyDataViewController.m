//
//  YLMyDataViewController.m
//  hdcy
//
//  Created by mac on 16/10/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLMyDataViewController.h"
#import "YLPersonInfoImageTableViewCell.h"
#import "YLPersonInfoLabelTableViewCell.h"
#import "YLCarStyleViewController.h"
#import "YLInterestViewController.h"
#import "YLPickerView.h"
#import "YLAddressViewController.h"
#import "YLNewPasswordViewController.h"
#import "YLPhoneViewController.h"
@interface YLMyDataViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,datePickerDidPickDelegate>
{
    YLPickerView *_datePicker;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation YLMyDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=BGColor;
    [self createNavigationBar];
    [self requestUrl];
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"个人资料";
    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-@2x" target:self selector:@selector(backAction)];

}
//返回
-(void)backAction
{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.8;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)requestUrl
{
    NSString *urlString=[NSString stringWithFormat:@"%@/user/current",URL];
    [YLHttp get:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:nil success:^(id json) {
        self.model=[[YLMineDataModel alloc]initWithDictionary:json error:nil];
        [self createTableView];
    } failure:^(NSError *error) {
        
    }];
}

//创建下面的tableview
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-70) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"YLPersonInfoImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"personImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YLPersonInfoLabelTableViewCell" bundle:nil] forCellReuseIdentifier:@"personLabelCell"];
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *indexDict=[self.dataSource objectAtIndex:indexPath.row];
    if (indexPath.row==0) {
        YLPersonInfoImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personImageCell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIImageView *back=[[UIImageView alloc]initWithFrame:cell.bounds];
        back.image=[UIImage imageNamed:@"touxiangbeijing"];
        cell.backgroundView=back;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.nameLabel.text=indexDict[@"name"];
        [cell.urlImageView sd_setImageWithURL:indexDict[@"image"] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
        return cell;
    }else{
        YLPersonInfoLabelTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"personLabelCell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.row%2) {
            UIImageView *back=[[UIImageView alloc]initWithFrame:cell.bounds];
            back.image=[UIImage imageNamed:@"nichengbeijing深"];
            cell.backgroundView=back;
        }else{
            UIImageView *back=[[UIImageView alloc]initWithFrame:cell.bounds];
            back.image=[UIImage imageNamed:@"xingmingbeijing浅"];
            cell.backgroundView=back;
        }
        if (indexPath.row==2) {
            
        }else{
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.nameLabel.text=indexDict[@"name"];
        cell.contentLabel.text=indexDict[@"content"];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 80;
    }else
        return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"头像修改"                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
            //添加Button
            [alertController addAction: [UIAlertAction actionWithTitle: @"本地相册" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //处理点击拍照
                [self getImageFromIpc:UIImagePickerControllerSourceTypePhotoLibrary];
            }]];
            [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                //处理点击从相册选取
                [self getImageFromIpc:UIImagePickerControllerSourceTypeCamera];
            }]];
            [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alertController animated: NO completion: nil];
        }
            break;
        case 1:{
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"编辑昵称"
                                                                                      message: nil
                                                                               preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = _model.nickname;
                textField.textColor = [UIColor blackColor];
                textField.clearButtonMode = UITextFieldViewModeAlways;
                textField.borderStyle = UITextBorderStyleRoundedRect;
            }];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSArray * textfields = alertController.textFields;
                UITextField * namefield = textfields[0];
                [self.dataSource removeObjectAtIndex:1];
                NSDictionary *dict=@{@"name":@"昵称",@"content":[NSString stringWithFormat:@"%@",namefield.text]};
                [self.dataSource insertObject:dict atIndex:1];
                
                NSString *urlString=[NSString stringWithFormat:@"%@/user/property",URL];
                NSDictionary *paraDict=@{@"name":@"nickname",@"value":namefield.text};
                [YLHttp put:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
                    [self.tableView reloadData];
                    self.headimageBlock(nil,namefield.text);
                } failure:^(NSError *error) {
                    
                }];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case 3:{
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"性别修改"                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction: [UIAlertAction actionWithTitle: @"男" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self.dataSource removeObjectAtIndex:3];
                NSDictionary *dict=@{@"name":@"性别",@"content":[NSString stringWithFormat:@"%@",@"男"]};
                [self.dataSource insertObject:dict atIndex:3];
                
                NSString *urlString=[NSString stringWithFormat:@"%@/user/property",URL];
                NSDictionary *paraDict=@{@"name":@"sex",@"value":@"1"};
                [YLHttp put:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
                    [self.tableView reloadData];
                } failure:^(NSError *error) {
                    
                }];
            }]];
            [alertController addAction: [UIAlertAction actionWithTitle: @"女" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self.dataSource removeObjectAtIndex:3];
                NSDictionary *dict=@{@"name":@"性别",@"content":[NSString stringWithFormat:@"%@",@"女"]};
                [self.dataSource insertObject:dict atIndex:3];
                
                NSString *urlString=[NSString stringWithFormat:@"%@/user/property",URL];
                NSDictionary *paraDict=@{@"name":@"sex",@"value":@"2"};
                [YLHttp put:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
                    [self.tableView reloadData];
                } failure:^(NSError *error) {
                    
                }];
            }]];
            [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alertController animated: NO completion: nil];
        }
            break;
        case 4:{
            YLPhoneViewController *phone=[[YLPhoneViewController alloc]init];
            [self presentViewController:phone animated:YES completion:nil];
        }
            break;
        case 5:{
            YLNewPasswordViewController *PW=[[YLNewPasswordViewController alloc]init];
            [self presentViewController:PW animated:YES completion:nil];
        }
            break;
        case 6:{
            _datePicker=[[YLPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-254, SCREEN_WIDTH, 254)];
            _datePicker.delegate=self;
            [self.view addSubview:_datePicker];
        }
            break;
        case 7:{
            YLAddressViewController *address=[[YLAddressViewController alloc]init];
            address.addressBlock=^(NSString *address){
                [self.dataSource removeObjectAtIndex:7];
                NSDictionary *dict=@{@"name":@"所在地",@"content":[NSString stringWithFormat:@"%@",address]};
                [self.dataSource insertObject:dict atIndex:7];
                [self.tableView reloadData];

            };
            [self presentViewController:address animated:YES completion:nil];
        }
            break;
        case 8:{
            YLCarStyleViewController *carStyle=[[YLCarStyleViewController alloc]init];
            carStyle.carStyleBlock=^(NSString *data){
                [self.dataSource removeObjectAtIndex:8];
                NSDictionary *dict=@{@"name":@"车型",@"content":[NSString stringWithFormat:@"%@",data]};
                [self.dataSource insertObject:dict atIndex:8];
                [self.tableView reloadData];
                
            };
            
            [self presentViewController:carStyle animated:YES completion:nil];
        }
            break;
        case 9:{
            YLInterestViewController *interest=[[YLInterestViewController alloc]init];
            interest.interestBlock=^(NSString *data){
                [self.dataSource removeObjectAtIndex:9];
                NSDictionary *dict=@{@"name":@"兴趣",@"content":[NSString stringWithFormat:@"%@",data]};
                [self.dataSource insertObject:dict atIndex:9];
                [self.tableView reloadData];
            };
            [self presentViewController:interest animated:YES completion:nil];
        }
            break;
         
        default:
            break;
    }
}

#pragma datePickerDidPickDelegate
-(void)dateConfirmWithDate:(NSString *)date
{
    [_datePicker removeFromSuperview];
    [self.dataSource removeObjectAtIndex:6];
    NSDictionary *dict=@{@"name":@"出生年月",@"content":date};
    [self.dataSource insertObject:dict atIndex:6];
    
    NSString *urlString=[NSString stringWithFormat:@"%@/user/property",URL];
    NSDictionary *paraDict=@{@"name":@"birthday",@"value":date};
    [YLHttp put:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(void)dismissVC
{
    [_datePicker removeFromSuperview];
}

- (void)getImageFromIpc:(NSInteger)sourceType
{
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]||![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.allowsEditing = YES;
    ipc.sourceType = sourceType;
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 设置图片
    UIImage *image= info[UIImagePickerControllerOriginalImage];
//    //设置image的尺寸
//    CGSize imagesize = image.size;
//    imagesize.height =626;
//    imagesize.width =413;
//    //对图片大小进行压缩--
//    image = [self imageWithImage:image scaledToSize:imagesize];
    NSData *imageData = UIImageJPEGRepresentation(image,1);
    NSString *urlSring=[NSString stringWithFormat:@"%@/image/upload",URL];
    [YLHttp postImage:imageData url:urlSring params:nil success:^(id json) {
        NSString *head=json[@"content"];
        [self.dataSource removeObjectAtIndex:0];
        NSDictionary *dict=@{@"name":@"头像",@"image":head};
        [self.dataSource insertObject:dict atIndex:0];
        [self.tableView reloadData];
        NSString *headimgurl=[NSString stringWithFormat:@"%@/user/property",URL];
        NSDictionary *paraDict=@{@"name":@"headimgurl",@"value":json[@"content"]};
        [YLHttp put:headimgurl userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
            self.headimageBlock(head,nil);
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        
    }];
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

-(void)setModel:(YLMineDataModel *)model
{
    _model=model;
    if (model.address==nil) {
        model.address=@"";
    }
    if ([model.sex isEqualToString:@"2"]) {
        model.sex=@"女";
    }else{
        model.sex=@"男";
    }
    if (model.mobile.length!=11) {
        
    }else{
        NSString *string = [model.mobile substringWithRange:NSMakeRange(3,4)];
        //字符串的替换
        model.mobile = [model.mobile stringByReplacingOccurrencesOfString:string withString:@"****"];
    }
    
    model.birthday=[YLGetTime getYYMMDDWithDate2:[NSDate dateWithTimeIntervalSince1970:[model.birthday doubleValue]/1000]];
}

#pragma ---------------------------懒加载--------------------------------
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[NSMutableArray arrayWithArray:@[@{@"name":@"头像",@"image":self.model.headimgurl},@{@"name":@"昵称",@"content":self.model.nickname},@{@"name":@"姓名",@"content":self.model.realname},@{@"name":@"性别",@"content":self.model.sex},@{@"name":@"手机",@"content":self.model.mobile},@{@"name":@"密码",@"content":@"**********"},@{@"name":@"出生年月",@"content":self.model.birthday},@{@"name":@"所在地",@"content":self.model.address},@{@"name":@"车型",@"content":self.model.car},@{@"name":@"兴趣",@"content":self.model.tags}]];
    }
    return _dataSource;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

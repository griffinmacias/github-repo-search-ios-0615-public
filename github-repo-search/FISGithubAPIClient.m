//
//  FISGithubAPIClient.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/5/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISGithubAPIClient.h"
#import "FISConstants.h"
#import <AFNetworking.h>
#import "FISGithubRepository.h"
@implementation FISGithubAPIClient
NSString *const GITHUB_API_URL=@"https://api.github.com";

+(void)getRepositoriesWithCompletion:(void (^)(NSArray *))completionBlock
{
    NSString *githubURL = [NSString stringWithFormat:@"%@/repositories?client_id=%@&client_secret=%@",GITHUB_API_URL,GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager GET:githubURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
    }];
}

+ (void)checkIfRepoIsStarredWithFullName:(NSString *)fullName CompletionBlock:(void (^)(BOOL ifStarred))statusCode
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [manager.requestSerializer setValue:@"token ded9a2b653fbf1aa66a02095fc533ae88080338d" forHTTPHeaderField:@"Authorization"];
    NSString *baseURL = @"https://api.github.com/user/starred/";
    NSString *ownerAndRepo = fullName;
    NSString *baseAndOandR = [NSString stringWithFormat:@"%@%@",baseURL, ownerAndRepo];

    [manager GET:baseAndOandR parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        statusCode(YES);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        statusCode(NO);
    }];
    
}

+ (void)starRepoWithFullName:(NSString *)fullName CompletionBlock:(void (^)(BOOL starred))statusCode
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [manager.requestSerializer setValue:@"token ded9a2b653fbf1aa66a02095fc533ae88080338d" forHTTPHeaderField:@"Authorization"];
    
    NSString *baseURL = @"https://api.github.com/user/starred/";
    NSString *ownerAndRepo = fullName;
    NSString *baseAndOandR = [NSString stringWithFormat:@"%@%@",baseURL, ownerAndRepo];
    
    [manager PUT:baseAndOandR parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        statusCode(YES);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        statusCode(NO);
    }];
}

+ (void)unstarRepoWithFullName:(NSString *)fullName CompletionBlock:(void (^)(BOOL unstarred))statusCode
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [manager.requestSerializer setValue:@"token ded9a2b653fbf1aa66a02095fc533ae88080338d" forHTTPHeaderField:@"Authorization"];
    
    NSString *baseURL = @"https://api.github.com/user/starred/";
    NSString *ownerAndRepo = fullName;
    NSString *baseAndOandR = [NSString stringWithFormat:@"%@%@",baseURL, ownerAndRepo];
    
    [manager DELETE:baseAndOandR parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        statusCode(YES);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        statusCode(NO);
    }];
}

+(void)toggleStarForRepository:(NSString *)fullName completion:(void (^)(BOOL))completionBlock
{
    [FISGithubAPIClient checkIfRepoIsStarredWithFullName:fullName CompletionBlock:^(BOOL ifStarred) {
        if (ifStarred) {
        [FISGithubAPIClient unstarRepoWithFullName:fullName CompletionBlock:^(BOOL unstarred) {
            completionBlock(NO);
        }];
        
        } else {
            [FISGithubAPIClient starRepoWithFullName:fullName CompletionBlock:^(BOOL starred) {
                completionBlock(YES);
            }];
        }
    }];
}

+(void)searchRepositoriesWithCompletion:(NSString *)keyword completionBlock:(void (^)(NSArray *))completionBlock
{
    NSString *githubURL = [NSString stringWithFormat:@"%@/search/repositories?client_id=%@&client_secret=%@",GITHUB_API_URL,GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET];
    NSDictionary *params = @{@"q":keyword};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:githubURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject[@"items"]);
        completionBlock(responseObject[@"items"]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
    }];
}


@end

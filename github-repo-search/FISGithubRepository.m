//
//  FISGithubRepository.m
//  ReviewSession 3-16-14
//
//  Created by Joe Burgess on 3/16/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISGithubRepository.h"

@implementation FISGithubRepository

-(instancetype)initWithFullName:(NSString *)fullName HtmlUrl:(NSURL *)htmlURL Repository:(NSString *)repositoryID
{
    self = [super init];
    
    if (self) {
        _fullName = fullName;
        _htmlURL = htmlURL;
        _repositoryID = repositoryID;
    }
    
    return self;
}
-(BOOL)isEqual:(id)object
{
    FISGithubRepository *repo2 = (FISGithubRepository *)object;
    NSString *urlA = [self.htmlURL absoluteString];
    NSString *urlB = [repo2.htmlURL absoluteString];
    return [repo2.repositoryID isEqualToString:self.repositoryID] && [repo2.fullName isEqualToString:repo2.fullName] && [urlA isEqualToString:urlB];
}

+ (FISGithubRepository *)makeRepoObject:(NSDictionary *)repoInfo
{
    FISGithubRepository *repo = [[FISGithubRepository alloc] initWithFullName:repoInfo[@"full_name"] HtmlUrl:[NSURL URLWithString:repoInfo[@"url"]] Repository:[repoInfo[@"id"] stringValue]];
    
    return repo;
}
@end

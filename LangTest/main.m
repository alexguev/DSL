//
//  main.m
//  LangTest
//
//  Created by David Astels on 1/5/12.
//  Copyright (c) 2012 Dave Astels. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "dsl.h"
#import "Tester.h"

int main(int argc, char *argv[])
{
  @autoreleasepool {
    @try {
      [Dsl initialize];
      Tester *t = [[Tester alloc]init];
      [t runTests];
    }
    @catch (NSException *ex) {
      int x = 5;
    }
  }
}


//
//  Binding.h
//  DSL
//
//  Created by David Astels on 9/29/10.
//  Copyright 2010 Dave Astels. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DslSymbol.h"
#import "DslExpression.h"


@interface Binding : NSObject {
  DslSymbol *symbol;
  DslExpression *value;
}

@property (retain, nonatomic) DslSymbol *symbol;
@property (retain, nonatomic) DslExpression *value;

+ (Binding*)withSymbol:(DslSymbol*)sym andValue:(DslExpression*)val;

@end

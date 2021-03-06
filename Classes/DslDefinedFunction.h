//
//  DslDefinedFunction.h
//  DSL
//
//  Created by David Astels on 9/29/10.
//  Copyright 2010 Dave Astels. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dsl.h"

@interface DslDefinedFunction : DslFunction {
  DslCons *parameters;
  DslCons *body;
}

+ (DslDefinedFunction*) withParameters:(DslCons*)p andBody:(DslCons*)b;
- (DslDefinedFunction*) init;
- (DslDefinedFunction*) initWithParameters:(DslCons*)p andBody:(DslCons*)b;

@end

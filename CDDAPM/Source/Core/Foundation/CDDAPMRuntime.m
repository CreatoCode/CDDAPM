//
//  CDDAPMRuntime.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/13.
//

#import <objc/runtime.h>
#import "CDDAPMLogger.h"
#import "CDDAPMRuntime.h"


void cddapm_exchangeMethod(Class originalClass, SEL originalSel, Class replacedClass, SEL replacedSel)
{
    Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
    Method replacedMethod = class_getInstanceMethod(replacedClass, replacedSel);
    IMP replacedMethodIMP = method_getImplementation(replacedMethod);
    BOOL didAddMethod = class_addMethod(originalClass, replacedSel, replacedMethodIMP, "v@:@@");
    if (didAddMethod) {
        CDDAPMLogDebug(@"class_addMethod success: %@", NSStringFromSelector(replacedSel));
    }
    Method newMethod = class_getInstanceMethod(originalClass, replacedSel);
    method_exchangeImplementations(originalMethod, newMethod);
}

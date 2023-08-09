//
//  Archiver.m
//  OpenStack
//
//  Created by Mike Mayo on 10/4/10.
//  The OpenStack project is provided under the Apache 2.0 license.
//

#import "Archiver.h"
#include <sys/xattr.h>

@implementation Archiver

+ (id)readFile:(NSString *)aFileName {
    
    NSLog(@"Read File Performed - %@",aFileName);
    
    @try {
        NSString *filePath = [Archiver getFilePath:aFileName];
        return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    @catch (NSException *exception) {
        [Archiver deleteFile:aFileName];
    }
}

+ (id)readFileFromGivenPath:(NSString *)filePath{
    
    NSLog(@"Read File Performed Path - %@",filePath);
    
    if (![filePath isKindOfClass:[NSString class]]) {
        return nil;
    }
    @try {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    @catch (NSException *exception) {
        [Archiver deleteFile:filePath];
    }
}

+ (NSDate*)createdOn:(NSString *)aFileName {
    NSString *filePath = [Archiver getFilePath:aFileName];
    
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    NSError *_error = nil;
    NSDictionary *_fileAttributes = [_fileManager attributesOfItemAtPath:filePath error:&_error];
    if (_fileAttributes) {
        return [_fileAttributes fileCreationDate];
    }
    return nil;
}

+ (BOOL)fileExists:(NSString *)aFileName {
    NSString *filePath = [Archiver getFilePath:aFileName];
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    return [_fileManager fileExistsAtPath:filePath];
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    NSError *error = nil;
    [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    return error == nil;
}

+ (BOOL)createFile:(id)object aFileName:(NSString *)aFileName {
        
    @try {

        NSString  *filePathString = [Archiver getFilePath:aFileName];
        NSURL * filePathStringURL = [NSURL URLWithString:filePathString];
        
        if (@available(iOS 11.0, *)) {

            NSError *error = nil;
            NSError *saveError = nil;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object requiringSecureCoding:NO error:&error];
            [data writeToFile:filePathString options:NSDataWritingAtomic error:&saveError];
            
            if (error == nil && saveError == nil) {
               // NSLog(@"File Creation Success-%@ -%@",object,aFileName);
                [Archiver addSkipBackupAttributeToItemAtURL:filePathStringURL];
                return true;
            } else if (error != nil) {
                //NSLog(@"File Creation Failure-%@ -%@ -%@",object,aFileName,[error localizedDescription]);
                [Archiver deleteFile:aFileName];
                return false;
            } else if (saveError != nil) {
                //NSLog(@"File Creation Failure-%@ -%@ -%@",object,aFileName,[saveError localizedDescription]);
                [Archiver deleteFile:aFileName];
                return false;
            } else {
                //NSLog(@"File Creation Failure-%@ -%@- Else Condition",object,aFileName);
                [Archiver deleteFile:aFileName];
                return false;
            }
        } else {
           
            if([NSKeyedArchiver archiveRootObject:object toFile:filePathString]) {
                //NSLog(@"File Creation Success less Than 11-%@ -%@",object,aFileName);
                [Archiver addSkipBackupAttributeToItemAtURL:filePathStringURL];
                return true;
            }
            
            //NSLog(@"File Creation Failure less Than 11-%@ -%@",object,aFileName);
            [Archiver deleteFile:aFileName];
            return false;
        }
    }
    @catch (NSException *exception) {
        [Archiver deleteFile:aFileName];
        return false;
    }
}

+ (NSString *)createFileWithData:(id)object aFileName:(NSString *)aFileName {
    
    NSLog(@"File Creation With Data -%@ -%@",object,aFileName);
    
    @try {
        NSString  *filePathString = [Archiver getFilePath:aFileName];
        NSURL * filePathStringURL = [NSURL URLWithString:filePathString];
        
        if (@available(iOS 11.0, *)) {
            NSError *error = nil;
            NSError *saveError = nil;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object requiringSecureCoding:NO error:&error];
            [data writeToFile:filePathString options:NSDataWritingAtomic error:&saveError];
            
            if (error == nil && saveError == nil) {
                NSLog(@"File Creation Success-%@ -%@",object,aFileName);
                [Archiver addSkipBackupAttributeToItemAtURL:filePathStringURL];
                return nil;
            } else if (error != nil) {
                NSLog(@"File Creation Failure-%@ -%@ -%@",object,aFileName,[error localizedDescription]);
                [Archiver deleteFile:aFileName];
                return [error localizedDescription];
            } else if (saveError != nil) {
                NSLog(@"File Creation Failure-%@ -%@ -%@",object,aFileName,[saveError localizedDescription]);
                [Archiver deleteFile:aFileName];
                return [saveError localizedDescription];
            } else {
                NSLog(@"File Creation Failure-%@ -%@- Else Condition",object,aFileName);
                [Archiver deleteFile:aFileName];
                return @" ";
            }
        } else {
            
            if([NSKeyedArchiver archiveRootObject:object toFile:filePathString]) {
                NSLog(@"File Creation Success less Than 11-%@ -%@",object,aFileName);
                [Archiver addSkipBackupAttributeToItemAtURL:filePathStringURL];
                return nil;
            }
            
            NSLog(@"File Creation Failure less Than 11-%@ -%@",object,aFileName);
            [Archiver deleteFile:aFileName];
            return @"  ";
        }
    }
    @catch (NSException *exception) {
        [Archiver deleteFile:aFileName];
        return exception.description;
    }
}



+ (BOOL)createFileAtGivenPath:(id)object aFilePath:(NSString *)aFilePath{
    
    @try {
        NSString  *filePathString = aFilePath;
        NSURL * filePathStringURL = [NSURL URLWithString:filePathString];
        
        if (@available(iOS 11.0, *)) {
            NSError *error;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object requiringSecureCoding:NO error:&error];
            [data writeToFile:filePathString options:NSDataWritingAtomic error:&error];

            if (error == nil) {
                [Archiver addSkipBackupAttributeToItemAtURL:filePathStringURL];
                return true;
            } else {
                [Archiver deleteFilePath:filePathString];
                return false;
            }
        } else {
            if([NSKeyedArchiver archiveRootObject:object toFile:filePathString]) {
                [Archiver addSkipBackupAttributeToItemAtURL:filePathStringURL];
                return true;
            }
            
            [Archiver deleteFilePath:filePathString];
            return false;
        }
    }
    @catch (NSException *exception) {
        [Archiver deleteFilePath:aFilePath];
        return false;
    }
}

+ (BOOL)deleteFile:(NSString *)aFileName {
    
    NSLog(@"File Delete -%@",aFileName);

    
    @try {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [Archiver getFilePath:aFileName];
        return [fileManager removeItemAtPath:filePath error:NULL];
    }
    @catch (NSException *exception) {
        return NO;
    }
}

+ (BOOL)deleteFilePath:(NSString *)filePath {
    
    NSLog(@"File Delete At Path -%@",filePath);
    
    @try {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        return [fileManager removeItemAtPath:filePath error:NULL];
    }
    @catch (NSException *exception) {
        return NO;
    }
}

+ (BOOL)deleteEverything {
    
    NSLog(@"deleteEverything");
    
    BOOL result = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *files = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    
    for (NSInteger i = 0; i < [files count]; i++) {
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[files objectAtIndex:i]];
        result = result && [fileManager removeItemAtPath:path error:NULL];
    }
    
    return result;
}

+ (NSString*)getFilePath:(NSString *)aFileName {
    
    NSLog(@"File Name at PAth - %@",aFileName);
    
    if (aFileName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        return [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.archive", aFileName]];
    }
    return nil;
}

@end

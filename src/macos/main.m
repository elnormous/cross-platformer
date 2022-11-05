#import <Cocoa/Cocoa.h>
#include <stdlib.h>
#include "game.h"

NSAutoreleasePool* pool = nil;
NSScreen* screen = nil;
NSWindow* window = nil;
NSView* content = nil;
NSObject<NSWindowDelegate>* windowDelegate = nil;

@interface AppDelegate: NSObject<NSApplicationDelegate>
{
}
@end

@implementation AppDelegate

-(void)applicationWillFinishLaunching:(__unused NSNotification*)notification
{
}

-(void)applicationDidFinishLaunching:(__unused NSNotification*)notification
{
}

-(void)applicationWillTerminate:(__unused NSNotification*)notification
{
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(__unused NSApplication*)sender
{
    return YES;
}

-(void)applicationDidBecomeActive:(__unused NSNotification*)notification
{
}

-(void)applicationDidResignActive:(__unused NSNotification*)notification
{
}

-(void)handleQuit:(__unused id)sender
{
    [[NSApplication sharedApplication] terminate:nil];
}

@end

@interface WindowDelegate: NSObject<NSWindowDelegate>
{
}

@end

@implementation WindowDelegate

-(void)windowDidResize:(__unused NSNotification*)notification
{
}

@end

static void initApp(void)
{
    pool = [[NSAutoreleasePool alloc] init];

    NSApplication* sharedApplication = [NSApplication sharedApplication];
    [sharedApplication activateIgnoringOtherApps:YES];
    [sharedApplication setDelegate:[[[AppDelegate alloc] init] autorelease]];

    NSMenu* mainMenu = [[[NSMenu alloc] initWithTitle:@"Main Menu"] autorelease];

    NSMenuItem* mainMenuItem = [[[NSMenuItem alloc] init] autorelease];
    [mainMenu addItem:mainMenuItem];

    NSMenu* subMenu = [[[NSMenu alloc] init] autorelease];
    [mainMenuItem setSubmenu:subMenu];

    NSMenuItem* quitItem = [[[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(handleQuit:) keyEquivalent:@"q"] autorelease];
    [quitItem setTarget: [sharedApplication delegate]];
    [subMenu addItem:quitItem];

    sharedApplication.mainMenu = mainMenu;
}

static void initWindow(void)
{
    // create window
    screen = [NSScreen mainScreen];

    CGSize windowSize;
    windowSize.width = round(screen.frame.size.width * 0.6);
    windowSize.height = round(screen.frame.size.height * 0.6);

    NSRect frame = NSMakeRect(round(screen.frame.size.width / 2.0F - windowSize.width / 2.0F),
                              round(screen.frame.size.height / 2.0F - windowSize.height / 2.0F),
                              windowSize.width, windowSize.height);

    const NSWindowStyleMask windowStyleMask = NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask;

    window  = [[NSWindow alloc] initWithContentRect:frame
                                          styleMask:windowStyleMask
                                            backing:NSBackingStoreBuffered
                                              defer:NO
                                             screen:screen];
    [window setReleasedWhenClosed:NO];

    window.acceptsMouseMovedEvents = YES;
    windowDelegate = [[WindowDelegate alloc] init];
    window.delegate = windowDelegate;

    [window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    NSString* bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    [window setTitle:bundleName];

    NSRect windowFrame = [NSWindow contentRectForFrameRect:[window frame]
                                                 styleMask:[window styleMask]];

    content = [[NSView alloc] initWithFrame:windowFrame];

    window.contentView = content;
    [window makeKeyAndOrderFront:nil];
}

static void runApp(void)
{
    NSApplication* sharedApplication = [NSApplication sharedApplication];
    [sharedApplication run];
}

static void releaseWindow(void)
{
    if (content) [content release];
    if (window)
    {
        window.delegate = nil;
        [window release];
    }
}

static void releasePool(void)
{
    if (pool) [pool release];
}

int main(int argc, const char * argv[])
{
    initApp();
    initWindow();

    init();
    runApp();

    releaseWindow();
    releasePool();

    return EXIT_SUCCESS;
}

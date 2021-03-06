//=======================================================================
//@V@:Note: This file generated by vgen V1.02 (02:00:29 AM 17 May 1998).
//	vbbbikecmdw.cpp:	Source for vbbbikeCmdWindow class
//=======================================================================

#include <v/vnotice.h>	// for vNoticeDialog
#include <v/vkeys.h>	// to map keys

#include "vbbbikecmdw.h"	// our header
#include "vbbbikeapp.h"

//	Start defines for the main window with 100

//@V@:BeginIDs
    enum {
	m_FirstCmd = 100, // Dummy Command
	m_Route,	// Route menu
	m_SearchStreet,
	btnTestTool,	// Tool Bar test
	lblTestStat,	// Status Bar test
	blkLast		// Last item
      };
//@V@:EndIDs

//@V@:BeginPulldownMenu FileMenu
    static vMenu FileMenu[] =
      {
	{"&New", M_New, isSens, notChk, noKeyLbl, noKey, noSub},
	{"&Open...", M_Open, isSens, notChk, noKeyLbl, noKey, noSub},
	{"&Save", M_Save, isSens, notChk, noKeyLbl, noKey, noSub},
	{"Save &as...", M_SaveAs, isSens, notChk, noKeyLbl, noKey, noSub},
	{"&Dump", M_Dump, isSens, notChk, noKeyLbl, noKey, noSub},
	{"&Close...", M_CloseFile, isSens, notChk, noKeyLbl, noKey, noSub},
	{"-", M_Line, notSens, notChk, noKeyLbl, noKey, noSub},
	{"E&xit", M_Exit, isSens, notChk, noKeyLbl, noKey, noSub},
	{NULL}
      };
//@V@:EndPulldownMenu

//@V@:BeginPulldownMenu EditMenu
    static vMenu EditMenu[] =
      {
	{"Cut  ", M_Cut, isSens, notChk, "Ctrl-X", 'X'-'@', noSub},
	{"Copy ", M_Copy, isSens, notChk, "Ctrl-C", 'C'-'@', noSub},
	{"Paste", M_Paste, isSens, notChk, "Ctrl-V", 'V'-'@', noSub},
	{NULL}
      };
//@V@:EndPulldownMenu

//@V@:BeginPulldownMenu TestDialog
    static vMenu RouteMenu[] =
      {
	{"SearchStreet", m_SearchStreet, isSens, notChk, noKeyLbl, noKey, noSub},
        {NULL}
      };
//@V@:EndPulldownMenu

//@V@:BeginMenu StandardMenu
    static vMenu StandardMenu[] =
      {
	{"&File", M_File, isSens, notUsed, notUsed, noKey, &FileMenu[0]},
	{"&Edit", M_Edit, isSens, notUsed, notUsed, noKey, &EditMenu[0]},
	{"&Route", m_Route, isSens, notUsed, notUsed, noKey, &RouteMenu[0]},
	{NULL}
      };
//@V@:EndMenu

//@V@:BeginCmdPane ToolBar
    static CommandObject ToolBar[] =
      {
	{C_Button,btnTestTool,0,"Test",NoList,CA_None,isSens,NoFrame,0,0},
	{C_EndOfList,0,0,0,0,CA_None,0,0,0}
      };
//@V@:EndCmdPane

//@V@:BeginStatPane StatBar
    static vStatus StatBar[] =
      {
	{"vBBBike", lblTestStat, CA_NoBorder, isSens, 0},
	{0,0,0,0,0}
      };
//@V@:EndStatPane

//====================>>> vbbbikeCmdWindow::vbbbikeCmdWindow <<<====================
  vbbbikeCmdWindow::vbbbikeCmdWindow(char* name, int width, int height) :
    vCmdWindow(name, width, height)
  {
    UserDebug1(Constructor,"vbbbikeCmdWindow::vbbbikeCmdWindow(%s) Constructor\n",name)

    // The Menu Bar
    vbbbikeMenu = new vMenuPane(StandardMenu);
    AddPane(vbbbikeMenu);

    /*
    // The Command Pane
    vbbbikeCmdPane = new vCommandPane(ToolBar);
    AddPane(vbbbikeCmdPane);
    */

    // The Canvas
    vbbbikeCanvas = new vbbbikeCanvasPane;
    AddPane(vbbbikeCanvas);

    /*
    // The Status Bar
    vbbbikeStatus = new vStatusPane(StatBar);
    AddPane(vbbbikeStatus);
    */

    // Associated dialogs

    vbbbikeDlg = new vbbbikeDialog(this,name);
    
    // Show Window

    ShowWindow();
    vbbbikeCanvas->ShowVScroll(1);	// Show Vert Scroll
    vbbbikeCanvas->ShowHScroll(1);	// Show Horiz Scroll
    vbbbikeCanvas->SetHScroll(800*100/8000, 36);
    vbbbikeCanvas->SetVScroll(600*100/8000, 43);

  }

//====================>>> vbbbikeCmdWindow::~vbbbikeCmdWindow <<<====================
  vbbbikeCmdWindow::~vbbbikeCmdWindow()
  {
    UserDebug(Destructor,"vbbbikeCmdWindow::~vbbbikeCmdWindow() destructor\n")

    // Now put a delete for each new in the constructor.

    delete vbbbikeMenu;
    delete vbbbikeCanvas;
    delete vbbbikeCmdPane;
    delete vbbbikeStatus;
    delete vbbbikeDlg;
  }

//====================>>> vbbbikeCmdWindow::KeyIn <<<====================
  void vbbbikeCmdWindow::KeyIn(vKey keysym, unsigned int shift)
  {
    int amount = 5;
    if (shift == 1) amount = 20;

    if (keysym == vk_Left || keysym == vk_KP_Left) {
      vbbbikeCanvas->HScroll(-amount);
    } else if (keysym == vk_Right || keysym == vk_KP_Right) {
      vbbbikeCanvas->HScroll(amount);
    } else if (keysym == vk_Up || keysym == vk_KP_Up) {
      vbbbikeCanvas->VScroll(-amount);
    } else if (keysym == vk_Down || keysym == vk_KP_Down) {
      vbbbikeCanvas->VScroll(amount);
    } else {
      fprintf(stderr, "%d %d %d\n",0, keysym, shift);

      vCmdWindow::KeyIn(keysym, shift);
    }
  }

//====================>>> vbbbikeCmdWindow::WindowCommand <<<====================
  void vbbbikeCmdWindow::WindowCommand(ItemVal id, ItemVal val, CmdType cType)
  {
    // Default: route menu and toolbar commands here


    UserDebug1(CmdEvents,"vbbbikeCmdWindow:WindowCommand(%d)\n",id)

    switch (id)
      {
	//@V@:Case M_New
	case M_New:
	  {
	    vNoticeDialog note(this);
	    note.Notice("New");
	    break;
	  }	//@V@:EndCase

	//@V@:Case M_Open
	case M_Open:
	  {
	    vNoticeDialog note(this);
	    note.Notice("Open");
	    break;
	  }	//@V@:EndCase

	//@V@:Case M_Save
	case M_Save:
	  {
	    vNoticeDialog note(this);
	    note.Notice("Save");
	    break;
	  }	//@V@:EndCase

	//@V@:Case M_SaveAs
	case M_SaveAs:
	  {
	    vNoticeDialog note(this);
	    note.Notice("Save As");
	    break;
	  }	//@V@:EndCase

#if 1
	case M_Dump:
	  {
	    (*((vbbbikeApp*)theApp)->str)->dump();
	    break;
	  }	//@V@:EndCase
#endif


	//@V@:Case M_CloseFile
	case M_CloseFile:
	  {
	    vNoticeDialog note(this);
	    note.Notice("Close File");
	    break;
	  }	//@V@:EndCase

	//@V@:Case M_Exit
	case M_Exit:
	  {
	    theApp->Exit();
	    break;
	  }	//@V@:EndCase

	//@V@:Case M_Cut
	case M_Cut:
	  {
	    vNoticeDialog note(this);
	    note.Notice("Cut");
	    break;
	  }	//@V@:EndCase

	//@V@:Case M_Copy
	case M_Copy:
	  {
	    vNoticeDialog note(this);
	    note.Notice("Copy");
	    break;
	  }	//@V@:EndCase

	//@V@:Case M_Paste
	case M_Paste:
	  {
	    vNoticeDialog note(this);
	    note.Notice("Paste");
	    break;
	  }	//@V@:EndCase

	//@V@:Case m_Dialog
	case m_SearchStreet:
	  {
	    if (!vbbbikeDlg->IsDisplayed())
		vbbbikeDlg->ShowDialog("Search Street");
	    break;
	  }	//@V@:EndCase


	//@V@:Case btnTestTool
	case btnTestTool:
	  {
	    vNoticeDialog note(this);
	    note.Notice("Tool Bar Test");
	    break;
	  }	//@V@:EndCase


	default:		// route unhandled commands up
	  {
	    vCmdWindow::WindowCommand(id, val, cType);
	    break;
	  }
      }
  }

import std.stdio;
import std.process;
import std.regex;
import std.file;
import std.algorithm;
import std.array;
import std.path;

//http://computers.tutsplus.com/tutorials/getting-spiffy-with-powerline--cms-20740

void main()
{
	
 auto locRegex = regex(r"Location: (.+)");

 auto getLoc = executeShell("pip show powerline-status");
 writeln(getLoc.output);
 
  auto locC = matchFirst(getLoc.output,locRegex);
  writeln(locC);
  if(!locC.empty){
  	writeln("Found existing install of powerline");
  	writeln("Getting config directories");
  	
   
    bool notInstalled = dirEntries(".", SpanMode.breadth).filter!(f => f.baseName == "powerline").array.empty;
    if(notInstalled){
      writeln("getting git content");
      auto command = executeShell("git clone https://github.com/powerline/powerline.git");
  	  writeln(command.output);	
    } else {
      writeln("git context already exists");
    }

     bool fontInstalled = dirEntries(".", SpanMode.breadth).filter!(f => f.baseName == "fonts").array.empty;
    if(fontInstalled){
      writeln("getting git fonts");
      auto command = executeShell("git clone https://github.com/powerline/fonts.git");
  	  writeln(command.output);	
    } else {
      writeln("git fonts already exists");
    }

    writeln("renaming Inconsolata font");
     bool renamed = exists("./fonts/Inconsolata/InconsolataPowerline.otf");
     if(!renamed){
        writeln("renaming");
        executeShell("mv ./fonts/Inconsolata/Inconsolata\\ for\\ Powerline.otf ./fonts/Inconsolata/InconsolataPowerline.otf");
     	} else {
     	 writeln("Font already renamed");
     	}
    
    auto loc = locC[1];
    bool notCpy = dirEntries(loc, SpanMode.breadth).filter!(f => f.baseName == "scripts").array.empty;
    if(notCpy){
    writeln("Copying scripts"); 	
    auto cpy1 = "cp -a ./powerline/powerline " ~ loc;
    auto cpy2 = "cp -a ./powerline/scripts " ~ loc;
    executeShell(cpy1);
    executeShell(cpy2);
    } else {
    	writeln("Already copied");
    }  
   

    auto configDir = expandTilde("~/.config/powerline");

    bool hasConfig = exists(configDir);
    if(!hasConfig){
    writeln("Copying config"); 	
    auto config1 = "mkdir -p ~/.config/powerline && cp -a ./powerline/powerline/config_files/* ~/.config/powerline";
    executeShell(config1);
    } else {
    	writeln("Config already copied");
    }  

     writeln("Next steps: ");
     writeln("1. install fonts/Inconsolata/InconsolataPowerline by double clicking it in the Finder");
     writeln("2. edit Terminal preferences > your chosen Theme > change the font to InconsolataPowerline 14px (or whatever size you like)");
     auto rcLoc = expandTilde("~/.bash_profile");
     writeln("3. add the following line to the end of your: " ~ rcLoc ~ " file (or whichever bash profile you use e.g. .bashrc");
     writeln("   source " ~ loc ~ "/powerline/bindings/bash/powerline.sh");	


  } else {
  	writeln("Installing powerline with pip");
  	// install powerline with pip
   auto pipCommand = executeShell("pip install --user git+git://github.com/Lokaltog/powerline");
   writeln(pipCommand.output);
  } 

  // .vimrc 

//  set rtp+=/Users/raguay/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim
 
//" These lines setup the environment to show graphics and colors correctly.
//set nocompatible
//set t_Co=256
 
//let g:minBufExplForceSyntaxEnable = 1
//python from powerline.vim import setup as powerline_setup
//python powerline_setup()
//python del powerline_setup
 
//if ! has('gui_running')
//   set ttimeoutlen=10
//   augroup FastEscape
//      autocmd!
//      au InsertEnter * set timeoutlen=0
//      au InsertLeave * set timeoutlen=1000
//   augroup END
//endif
 
//set laststatus=2 " Always display the statusline in all windows
//set guifont=Inconsolata\ for\ Powerline:h14
//set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)






}

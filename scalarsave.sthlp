{smcl}

{p2colset 5 19 21 2}{...}
{p2col :{hi:scalarsave} {hline 2} Save numeric scalar values to delimited files.}{p_end}
{p2colreset}{...}

{marker syntax}{title:Syntax}

{p 8 15 2}
{cmd:scalarsave using}
{it :{help filename}}{cmd:,} 
{cmd:scalar(}{it:real} [{it:, {help scalarsave##scalars_options:scalar_options}}]{cmd:)} 
{opt id(string)}
[ {opt replace} {opt delim(string)} ]

{synoptset 26 tabbed}{...}
{marker options}{...}
{synopthdr :options}
{synoptline}
{syntab:Required}
{synopt :{opth scalar(real)}}scalar to save. See {it:{help scalarsave##scalars_options:scalar_options}} for sub-options. {p_end}
{synopt :{opth id(string)}}id or name for the scalar.{p_end}

{syntab:Optional}
{synopt :{opt replace}}replace the using {it :{help filename}}.{p_end}
{synopt :{opth delim(string)}}delimiter to use to separate items in {it :{help filename}}. Defaults to {cmd: ","}.{p_end}
{synoptline}

{synoptset 26 tabbed}{...}
{marker scalar_options}{...}
{synopthdr :scalar_options}
{synoptline}
{synopt :{opth fmt(fmt)}}format to apply to scalar before saving to file.{p_end}
{synopt :{opt update}}update the scalar with {opt id} in the using file.{p_end}
{synoptline}

{marker description}{...}
{title:Description}

{pstd}
{cmd: scalarsave} lets the user save numeric scalar values with ids to delimited .txt or .csv file. Each time the function is called a new line is added
to the file. The delimiter can be specified but defaults to comma separated values. This program was created to be used with LaTeX's {cmd: datatool} package 
to programmatically insert numbers into the text of academic papers.  

{marker options_desc}{...}
{title:Options for scalarsave}

{phang}
{opth scalar(real)} is where you specify the scalar you want to save. The scalar must be numeric. There are several sub-options that can be
passed to the {cmd: scalar} option. You can specify the formatting of the scalar using the {opth fmt(fmt)} sub-option. If you want to replace 
a scalar in an already existing file you must specify the {opt update} sub-option. If the scalar doesn't exist in the using file and you specify 
{opt update} the program will throw an error. If you specify {opt update} and a scalar with the specified {cmd: id} does not exist in the using 
file the program will throw an error.

{phang}
{opth id(string)} is where you specify the name to be associated with the scalar. The entry will appear as {cmd: "id,scalar"} in the 
output file (unless a different delimiter is specified in which case the comma will be replaced). 

{phang}
{opt replace} specifies the program should overwrite the using file. 

{phang}
{opth delim(string)} lets you change the delimiter used. The defaul delimiter is a comma.

{title:Examples}

{pstd}Save a scalar{p_end}
{phang2}{cmd:. scalarsave using example.txt, scalar(100.256, fmt(%3.2f)) id("Example scalar")}

{pstd}Update a scalar{p_end}
{phang2}{cmd:. scalarsave using example.txt, scalar(100, update) id("Example scalar")}

{pstd}Use a new delimiter{p_end}
{phang2}{cmd:. scalarsave using example.txt, scalar(100) id("New scalar") delim(=)}

{title:Author}

{pstd} Contact Danny Onorato for questions or concerns (onorato.danny@gmail.com) {p_end}

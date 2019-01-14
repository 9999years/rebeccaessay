\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rebeccaessay}[2019/01/11 1.0.0 Personal document class for MLA-cited essays]
\errorcontextlines 10

\RequirePackage{xparse}

\PassOptionsToClass{12pt}{article}
\PassOptionsToPackage{
	fonts,
	footnote,
	quote,
	bib
}{rebeccastyle}

% passes an option to rebeccastyle
\newcommand{\rebeccaessay@passoption}[1]
	{\DeclareOption{#1}{%
		\PassOptionsToPackage{\CurrentOption}{rebeccastyle}%
	}}

% pass a comma-list of options
\NewDocumentCommand{\rebeccaessay@passoptions}{>{\SplitList{,}} m}
	{\ProcessList{#1}{\rebeccaessay@passoption}}

% options for rebeccastyle
\rebeccaessay@passoptions{
	tabu, notabu,
	figure, nofigure,
	list, nolist,
	coverletter, nocoverletter,
	fonts, nofonts,
	times, garamond,
	footnote, nofootnote,
	quote, noquote,
	1, 1.5, 2,
	bib, nobib,
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions*

\LoadClass{article}
\RequirePackage{rebeccastyle}

% util
\RequirePackage{changepage} % for adjustwidth env
\RequirePackage{etoolbox} % for suppressindent

% formatting
\newcommand*\NoIndentAfterEnv[1]{\AfterEndEnvironment{#1}{\suppressindent}}
\NoIndentAfterEnv{displayquote}
\NoIndentAfterEnv{enumerate}

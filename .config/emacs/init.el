;;; init.el --- Personal Emacs configuration -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

;; Clamp down Emacs version to at least "30.2"
(when (version< emacs-version "30.2")
  (error "Need at least emacs 30.2"))

;;; Build-in packages
(use-package use-package
  :init
  (setq use-package-verbose t)
  (setq use-package-compute-statistics t))

(use-package use-package-ensure-system-package
  :after use-package)

(use-package package
  :config
  (add-to-list 'package-archives
	       '("melpa" .  "https://melpa.org/packages/") t))

(use-package emacs
  :custom
  (inhibit-startup-screen t "disable the startup screen")
  (use-short-answers t "uses shorter answers y or n")
  (ring-bell-function nil "turn off bell")
  (vc-follow-symlinks t "follow symlinks without requesting confirmation.")
  (confirm-kill-emacs 'y-or-n-p "confirm before exiting emacs.")
  (use-file-dialog nil)
  (use-dialog-box nil)
  (delete-by-moving-to-trash t "move deleted files to trash")
  (electric-pair-mode t "enable automatic brackets pairing.")
  (column-number-mode t "show cloumn numbers in modline.")
  (warning-minimum-level :error "only show errors in *warning* buffer. (maybe not so good)")
  (fill-column 100)
  :bind (("<escape>" . keyboard-escape-quit))
  :config

  (setq ring-bell-function 'ignore)

  (add-to-list 'default-frame-alist
	       '(font . "DejaVu Sans Mono-18:bold:italic"))


  (add-hook 'prog-mode-hook (lambda ()
			      (setq display-line-numbers 'relative)))

  ;; Move customization variables to a separate file and load it.
  (setq custom-file (expand-file-name "custom-vars.el" user-emacs-directory))
  (load custom-file 'noerror 'nomessage))

(use-package hl-line
  :hook
  ((prog-mode . hl-line-mode)
   (text-mode . hl-line-mode)))

(use-package display-fill-column-indicator
  :hook ((prog-mode . display-fill-column-indicator-mode)))

(use-package whitespace
  :custom (whitespace-line-column nil "if nil, use the value of the ‘fill-column’ variable")
  :bind (("C-c w" . whitespace-mode)
	 ("C-c c" . whitespace-cleanup)))

(use-package icomplete
  :custom
  (fido-mode 1 "enable fido-mode"))

(use-package man
  :bind (("C-c m" . man)))

(use-package isearch
  :custom
  (search-default-mode t))

(use-package files
  :custom
  (backup-directory-alist '(("." . "~/.config/.saves")) "file backup directory")
  (delete-old-versions t "delete excess numbered backup files")
  (kept-new-versions 6 "number of newest versions to keep when a new numbered backup is made")
  (kept-old-versions 2 "number of oldest versions to keep when a new numbered backup is made")
  (version-control t "control use of version-numbered backup files"))

(use-package todo-mode
  :custom
  (todo-directory "~/vault/todo/")
  :bind (("C-c t" . todo-show)
	 ("C-c i" . todo-insert-item)
	 ("C-c j" . todo-jump-to-category)))

(use-package org
  :custom
  (org-hide-leading-stars t)
  :custom-face
  (org-level-1 ((t (:height 1.35))))
  (org-level-2 ((t (:height 1.3))))
  (org-level-3 ((t (:height 1.2))))
  (org-level-4 ((t (:height 1.1))))
  (org-level-5 ((t (:height 1.1))))
  (org-level-6 ((t (:height 1.1))))
  (org-level-7 ((t (:height 1.1))))
  (org-level-8 ((t (:height 1.1)))))

(use-package eshell
  :custom (eshell-prefer-lisp-functions t "prefer lisp functions to external commands")
  :bind (("C-x e" . eshell))
  :config
  (require 'em-alias)
  (eshell/alias "ff" "find-file $1")
  (eshell/alias "d" "dired $1")
  (eshell/alias "cal" "calendar")
  (eshell/alias "la" "ls -ah")
  (eshell/alias "ll" "ls -ahl")
  (eshell/alias "c" "clear-scrollback"))

(use-package flyspell-mode
  :bind ((:map text-mode-map
	       ("C-c f" . flyspell-mode))
	 (:map prog-mode-map
	       ("C-c f" . flyspell-prog-mode))
	 ("C-c d" . ispell-change-dictionary)))

(use-package dired
  :custom
  (dired-listing-switches "-agho --ignore-backups --group-directories-first")
  (dired-dwim-target t)
  (dired-isearch-filenames t))

;;; External packages

(use-package all-the-icons-dired
  :if (display-graphic-p)
  :pin melpa
  :ensure t
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package emacs
  :init
  (require-theme 'modus-themes)
  :bind (("<f5>" . modus-themes-toggle))
  :config
  (setq modus-themes-common-palette-overrides
	'((docstring green-faint)
	  (docmarkup magenta-faint)
	  (comment yellow-cooler)
	  (string green-cooler)))
  (modus-themes-load-theme 'modus-vivendi))

(use-package gruvbox-theme
  :disabled
  :pin nongnu
  :ensure t
  :preface
  (defun switch-theme ()
    (interactive)
    (let ((dark 'gruvbox-dark-hard)
	  (light 'gruvbox-light-hard))
      (cond ((memq dark custom-enabled-themes)
	     (disable-theme dark)
	     (load-theme light t))
	    ((memq light custom-enabled-themes)
	     (disable-theme light)
	     (load-theme dark t)))))
  :bind (("<f5>" . 'switch-theme))
  :hook ((prog-mode . (lambda () (highlight-regexp "\\(TODO\\|NOTE\\):" 'hi-blue-b))))
  :config
  (load-theme 'gruvbox-dark-hard t)
  :custom-face
  (whitespace-space ((t (:foreground "#504945"))))
  (todo-date ((t (:foreground "#fabd2f"))))
  (todo-nondiary ((t (:foreground "#83a598")))))

(use-package solarized-theme
  :disabled
  :pin nongnu
  :ensure t
  :config
  (load-theme 'solarized-dark))

(use-package system-packages
  :ensure t)

(use-package slime
  :ensure-system-package sbcl
  :pin nongnu
  :ensure t
  :defer t
  :config
  (setq inferior-lisp-program "sbcl")
  (add-to-list 'slime-contribs 'slime-autodoc))

(use-package clhs
  :after slime
  :pin melpa
  :ensure t
  :config
  (load (concat (getenv "HOME") "/quicklisp/clhs-use-local.el") t))

(use-package multiple-cursors
  :pin nongnu
  :ensure t
  :bind (("C-c i"   . mc/edit-lines)
	 ("C->"	    . mc/mark-next-like-this)
	 ("C-<"	    . mc/mark-previous-like-this)
	 ("C-c C-<" . mc/mark-all-like-this)
	 ("C-c C->" . mc/mark-all-dwim)))

(use-package company
  :pin gnu
  :ensure t
  :hook
  ((prog-mode . company-mode)
   (text-mode . company-mode)))

(use-package yasnippet
  :pin gnu
  :ensure t
  :hook ((prog-mode . yas-minor-mode)))

(use-package yasnippet-snippets
  :after yasnippet
  :pin nongnu
  :ensure t)

(use-package magit
  :ensure-system-package git
  :pin nongnu
  :ensure t
  :defer t)

(use-package geiser-guile
  :pin nongnu
  :ensure t
  :defer t)

(use-package adoc-mode
  :pin nongnu
  :ensure t
  :defer t)

(use-package markdown-mode
  :pin nongnu
  :ensure t
  :defer t)

(use-package rainbow-mode
  :pin gnu
  :ensure t
  :defer t)

(use-package go-mode
  :pin nongnu
  :ensure t
  :defer t)

(use-package lua-mode
  :ensure-system-package lua5.4
  :pin nongnu
  :ensure t
  :defer t)

(use-package forth-mode
  :pin nongnu
  :ensure t
  :defer t)

(use-package nasm-mode
  :ensure-system-package nasm
  :pin nongnu
  :ensure t
  :defer t
  :mode ("\\.s\\'" "\\.S\\'" "\\.asm\\'" "\\.inc\\'"))

(use-package elfeed
  :ensure-system-package mpv
  :pin nongnu
  :ensure t
  :defer t
  :preface
  (defun elfeed-open-in-mpv ()
    (interactive)
    (let ((selected-feeds (elfeed-search-selected t)))
      (when (null selected-feeds)
	(message "elfeed-open-in-mpv: nothing selected!"))
      (let ((link (elfeed-entry-link selected-feeds)))
	(if (length> link 0)
	    (start-process-shell-command
	     "mpv" "elfeed-mpv" (string-join (list "mpv" link) " "))
	  (message "elfeed-open-in-mpv: nothing selected!")))))
  :bind (("C-c r" . elfeed)
	 (:map elfeed-search-mode-map
	       ("C-c m" . 'elfeed-open-in-mpv)))
  :custom
  (elfeed-search-title-max-width 80)
  (elfeed-db-directory (concat user-emacs-directory "/.elfeed"))
  :config
  (elfeed-search-set-filter "@1-months-ago +unread -emacs -youtube")
  (add-hook 'elfeed-new-entry-hook
	    (elfeed-make-tagger :before "4 weeks ago"
				:remove 'unread))
  (setq elfeed-feeds
	;; The last Youtubers I'm thinking of are still worth
	;; watching. I think I'll drop them soon.
	'(;; Diesel Creek
	  ("https://www.youtube.com/feeds/videos.xml?playlist_id=UULFBB0oz7Yo_35gnbPYGKGJTA" youtube)
	  ;; Scrappy Industries
	  ("https://www.youtube.com/feeds/videos.xml?playlist_id=UULFyacDPsLkX-KDqYMZPpmtDQ" youtube)
	  ;; Welker Farms
	  ("https://www.youtube.com/feeds/videos.xml?playlist_id=UULFtKUW8LJK2Ev8hUy9ZG_PPA" youtube)
	  ;; Tsoding
	  ("https://www.youtube.com/feeds/videos.xml?playlist_id=UULFrqM0Ym_NbK1fqeQG2VIohg" youtube)
	  ("https://www.youtube.com/feeds/videos.xml?playlist_id=UULFEbYhDd6c6vngsF5PQpFVWg" youtube)
	  ;; Blogs
	  ("https://planet.emacslife.com/atom.xml" emacs)
	  ("https://daniel.haxx.se/blog/feed/" blog)
	  ("https://suckless.org/atom.xml" blog))))

(use-package emms
  :ensure-system-package mpv
  :pin gnu
  :ensure t
  :defer t
  :preface
  (defcustom playlists-path "~/Music/playlists/"
    "Path for playlists used by `play-playlist' function."
    :type 'string)

  (defun play-playlist ()
    "This function first sets `emms-source-file-default-directory'
 to `playlists-path' and than `emms-play-playlist' interactively."
    (interactive)
    (emms-stop)
    (setq emms-source-file-default-directory playlists-path)
    (call-interactively 'emms-play-playlist)
    (emms-playlist-mode-go))

  (defcustom just-play-path "~/Music/"
    "Path for playlists used by `play-playlist' function."
    :type 'string)

  (defun just-play ()
    "Just playn what ever is at `just-play-path'"
    (interactive)
    (emms-stop)
    (setq emms-source-file-default-directory just-play-path)
    (call-interactively 'emms-play-file))
  :custom
  (emms-player-list '(emms-player-mpv))
  (emms-info-functions '(emms-info-native))
  (emms-source-file-default-directory "~/Music/")
  (emms-repeat-playlist t)
  (emms-mode-line-format "")
  :bind
  (("C-c e i" . emms)
   ("C-c e g" . 'emms-playlist-mode-go)
   ("C-c e f" . 'just-play)
   ("C-c e b" . 'emms-browser)
   ("C-c e p" . 'play-playlist)
   ("C-c e r" . 'emms-toggle-repeat-track)
   ("<XF86AudioPlay>"  . 'emms-pause )
   ("<<XF86AudioStop>" . 'emms-pause )
   ("<XF86AudioPrev>"  . 'emms-previous)
   ("<XF86AudioNext>"  . 'emms-next))
  :config
  (emms-all))

;;; init.el ends here

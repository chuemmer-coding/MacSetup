;; This is start up file that enables features
;; that would normally be found in an IDE
;;
;; Features include autocompletion, mathing parenthesis
;; remote host editing, variable refactoring, in editor
;; compile options
;;
;; README:
;; To use and install all packages used in this init file,
;; simply replace ~/.emacs with this file and open emacs.
;; Emacs will take a moment to install all the missing
;; packages and resolve everything for you.
;; Recommended that you remove ~/.emacs and
;; use ~/.emacs.d/init.el instead. This way all relevant
;; emacs files are in .emacs.d/ and this allows version
;; controlling.
;;
;; Updating: when changes are made to this file, the easy update
;; is restarting emacs. M-x eval-buffer will also update the
;; current session, BUT may require closing and opening buffers.
;;

(package-initialize) ;; Must be first in file
(setq user-full-name "Colin Huemmer"
      user-mail-address "chuemmer@terpmail.umd.edu")

;; adds more repos for adding packages
(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("melpa" . "http://melpa.org/packages/")
	("marmalade" . "http://marmalade-repo.org/packages/")))
(setq package-enable-at-startup nil)

(global-linum-mode) ;;Line number in all buffers
(setq-default c-basic-offset 3) ;;C indentation
(fset 'yes-or-no-p 'y-or-n-p) ;;lets you type y instead of yes

;;TO PREVENT MERLIN FROM SCREWING ME AND CLOSING MY EMACS, LET'S CHANGE
;;C-X C-C TO SOMETHING ELSE
(global-set-key (kbd "C-x C-c") 'er/expand-region)

;;If 'use-package' is not installed install it
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;; Evil: adds vim commands to emacs
(use-package evil
  :ensure t
  :init
  (evil-mode t)
  ;;Better Undo than default.
  ;;Default will undo entire instert mode changes.
  (setq evil-want-fine-undo t)
  ;;M-x l-c-d <----for color options
  (setq evil-insert-state-cursor '((bar . 9) "DeepPink2")
	evil-normal-state-cursor '((bar . 9) "dark violet"))
  (define-key evil-motion-state-map (kbd "C-r") 'undo-tree-redo))
  ;;Origami: allows folding of methods in source code.
  ;; 'za' for open and close in evil
  (use-package origami
    :ensure t
    :init (global-origami-mode t))
  

(use-package challenger-deep-theme
  :ensure t
  :init (load-theme 'challenger-deep t)
)

;; whitespace: changes the color of the text past an 80 character limit
(use-package whitespace
  :ensure t
  :init
  (setq whitespace-line-column 80) ;; limit
  ;; Remove the following line if the red and yellow are annoying
  (setq whitespace-style '(face empty tabs lines-tail trailing))
  (global-whitespace-mode t)
  )

;; dashboard: Better welcome screen than default 
(use-package dashboard
  :ensure t
  :config (dashboard-setup-startup-hook))

;; tramp: Edit files from a remote machine such as grace
;; i.e.:  C-x C-f /sshx:user@grace.umd.edu:~/
(use-package tramp
  :ensure t
  :init (setq tramp-default-method "sshx")
  )

;; neotree: Creates a side window for viewing the filesystem
;;          To toggle on/off press f8.
;;          To show hidden files press H
(use-package neotree
  :ensure t
  :init
  (global-set-key [f8] 'neotree-toggle)
  )

;; iedit: Rename variables in a file
;;        activate/deactivate with C-;
;;        insert mode made in heaven
(use-package iedit
  :ensure t)

;; ace-mc: multiple cursors, you must play with it to understand. 
(use-package ace-mc
  :ensure t
  :init
  (global-set-key (kbd "M-f") 'ace-mc-add-multiple-cursors)
)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(use-package tuareg
  :ensure t
  :init
  ;;(autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
  ;;(add-hook 'tuareg-mode-hook 'utop-minor-mode)
  (add-hook 'tuareg-mode-hook 'merlin-mode)
  (add-hook 'tuareg-mode-hook #'merlin-mode)
  (add-hook 'caml-mode-hook #'merlin-mode) ; If you really like to use Caml Mode
)

;; merlin is super good/useful for debugging ocaml, it will
;; make like 10x easier
(use-package merlin
   :ensure t
   :init
   (with-eval-after-load 'merlin
   (setq merlin-command 'opam))
   (let ((opam-share (ignore-errors (car (process-lines "opam" "config" "var"
						     "share")))))
   (when (and opam-share (file-directory-p opam-share))
    ;; Register Merlin
    (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
    (autoload 'merlin-mode "merlin" nil t nil)
    ;; Automatically start it in OCaml buffers
    (add-hook 'tuareg-mode-hook 'merlin-mode t)
    (add-hook 'caml-mode-hook 'merlin-mode t)
    ;; Use opam switch to lookup ocamlmerlin binary
    (setq merlin-command 'opam)))
)


;; flycheck: On the fly syntax checking in C
;;           if you mouse over the error it will
;;           explain what is wrong
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  )

;; company: Basic auto completion 
(use-package company
  :ensure t
  :init (add-hook 'after-init-hook 'global-company-mode)
  ;; tamper with these if it doesn't work for some reason...
  ;;(setq company-dabbrev-downcase 0)
  ;;(setq company-idle-delay 0)
  ;;(require 'company-irony)
  ;;(eval-after-load 'company
  ;;'(add-to-list 'company-backends 'company-irony))
  ;;(require 'company-irony-c-headers)
  ;;(eval-after-load 'company
  ;;'(add-to-list
  ;;'company-backends 'company-irony-c-headers company-irony)))
  ;;(setq company-global-modes '(not shell-mode))
  )

;;expand-region: Highlights the next region
;; 		 do this a few times to see
;;		 what it really does 'C-e' 
(use-package expand-region
  :ensure t
  :init
  ;;Note this binding is needed if evil-mode is active
  (define-key evil-motion-state-map (kbd "C-e") 'er/expand-region)
  ;;(global-set-key (kbd "C-e") 'er/expand-region)
  )

;;multi-compile: compile inside in emacs
;;               This is nice when there are error.
;;               Clicking on errors takes you directly
;;               to the error in the file.
(use-package multi-compile
  :ensure t
  :init
  (global-set-key (kbd "M-c") 'multi-compile-run)
  (setq multi-compile-alist
	'(
	  (c-mode . (("gcc" . "gcc -g %file-name")
		     ("make" . "make")
		     ("clean" . "make clean")))
	  (latex-mode . (("pdflatex" . "pdflatex %file-name")))

	  )
	;; more compile commands can be added here.
	)
;;  (defun bury-compile-buffer-if-successful (buffer string)
;;    "Bury a compilation buffer if succeeded without warnings "
;;    ;; can be annoying with build tools like ant
;;    (when (and
;;	   (buffer-live-p buffer)
;;	   (string-match "compilation" (buffer-name buffer))
;;	   (string-match "finished" string)
;;	   (not
;;	    (with-current-buffer buffer
;;	      (goto-char (point-min))
;;	      (search-forward "warning" nil t))))
;;      (run-with-timer 1 nil
;;		      (lambda (buf)
;;			(bury-buffer buf)
;;			(switch-to-prev-buffer (get-buffer-window buf) 'kill))
;;		      buffer)))
  (add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)
  )

(defun my-prettify-c-block-comment (orig-fun &rest args)
  (let* ((first-comment-line (looking-back "/\\*\\s-*.*"))
         (star-col-num (when first-comment-line
                         (save-excursion
                           (re-search-backward "/\\*")
                           (1+ (current-column))))))
    (apply orig-fun args)
    (when first-comment-line
      (save-excursion
        (newline)
        (dotimes (cnt star-col-num)
          (insert " "))
        (move-to-column star-col-num)
        (insert "*/"))
      (move-to-column star-col-num) ; comment this line if using bsd style
      (insert "*") ; comment this line if using bsd style
     ))
  ;; Ensure one space between the asterisk and the comment
  (when (not (looking-back " "))
    (insert " ")))
(advice-add 'c-indent-new-comment-line :around #'my-prettify-c-block-comment)
;; (advice-remove 'c-indent-new-comment-line #'my-prettify-c-block-comment)

;;smartparens: auto complete start end characters
;;             such as {} [] '' "" `` 
;;(use-package smartparens
;;  :ensure t
;;  :init
;;  (add-hook 'after-init-hook 'smartparens-global-mode)
  ;;gets rid of the annoying compile warnings from smartparens
;;  (add-hook 'window-setup-hook
;;	    '(lambda ()
;;	       (kill-buffer "*Compile-Log*")
;;	       (delete-other-windows)))
;;  )

;;ORG MODE: uncomment when emacs lvl99 
;;(use-package org
;;  :ensure t
;;  :init
;;  (setq org-ellipsis "▾")
;;  
;;  (add-hook 'org-mode-hook 'flyspell-mode)
;;  (global-set-key (kbd "H-z") 'ispell-word)
;;  (setq org-agenda-files '("~/Dropbox"))
;;  (global-set-key (kbd "H-q") 'org-agenda)
;;  (use-package org-bullets
;;    :ensure t
;;    :init 
;;    (add-hook 'org-mode-hook
;;	      (lambda ()
;;		(org-bullets-mode t)))
;;    (org-babel-do-load-languages
;;     'org-babel-load-languages
;;     '((C . t)
;;       (ruby . t)
;;       (ocaml . t)
;;       (sh . t)
;;       (dot . t)
;;       (R . t)
;;       ))
;;    )
;;  (defun fill-setup()
;;    "sets the column to 80 and sets minor mode auto-fill-mode"
;;    (set-fill-column 80)
;;    (auto-fill-mode t))
;;  (add-hook 'org-mode-hook 'fill-setup)
;;  )

;;TESTING RUST MODE
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (challenger-deep)))
 '(delete-selection-mode nil)
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (rust-playground racer flycheck-rust rust-mode multi-compile expand-region company flycheck merlin ace-mc iedit neotree dashboard challenger-deep-theme use-package origami evil)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

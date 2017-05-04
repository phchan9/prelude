;; required extra package
(prelude-require-packages '(neotree js2-refactor ag xref-js2
                                    zerodark-theme tern
                                    exec-path-from-shell
                                    company-tern rjsx-mode))

;; set theme
(load-theme 'zerodark t)

;; set font size and font type
(if (equal system-type 'darwin)
    (set-frame-font "Courier 16")
  (set-frame-font "Monospace 16"))

;; Accoring to perlude-custom.el, I can define this variable as a personal usage
(setq prelude-user-init-file load-file-name)

(defun ph-open-my-custom-file ()
  "Edit the `ph-custom-file`, in another window. If there is
is only one visible window, it will split another one window
at right"
  (interactive)
  (split-window-right)
  (find-file-other-window prelude-user-init-file))

;; set global keybinding
(global-set-key (kbd "C-c 1") 'ph-open-my-custom-file)

(if (equal system-type 'darwin)
    (global-set-key (kbd "C-c C-f 1") 'toggle-frame-fullscreen))

;; set rainbow mode to css hook
(add-hook 'css-mode-hook 'rainbow-mode)

;; set linum mode
(global-linum-mode 1)

;; set visual line mode
(global-visual-line-mode 1)

;; set auto pair
(electric-pair-mode 1)

;; set neotree keybinding
(global-set-key (kbd "<f8>") 'neotree-toggle)
(setq projectile-switch-project-action 'neotree-projectile-action)
(setq neo-theme 'ascii)

;; set exec-path consist with PATH environment variable
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; set js2 and tern
(require 'js2-mode)
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))
(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js-mode-hook (lambda () (tern-mode t)))
(add-hook 'js2-mode-hook #'tern-mode)

;; set up company backend for tern
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'js-mode-hook (lambda () (setq-local company-backends '(company-tern))))

;; add js2-refactor and xref-js2 mode
(require 'js2-refactor)
(require 'xref-js2)

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; better imenu for js2 mode
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; js-mode (which js2 is based on) binds "M-." which conflicts with
;; xref, so unbind it.
(define-key js-mode-map (kbd "M-.") nil)
(add-hook 'js2-mode-hook (lambda ()
                           (add-hook 'xref-backend-functions
                           #'xref-js2-xref-backend nil t)))

;; rxjs mode for react development
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))

;; start emacs server
(server-start)

(provide 'ph-custom)
;;; ph-custom.el ends here

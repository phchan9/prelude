;; set font size and font type
(set-default-font "Monospace 15")

;; set key binding to open this my-custom file
(defvar ph-custom-dir (expand-file-name "personal" (file-name-directory user-init-file))
  "This directory is for phchang's customization.")

(defvar ph-custom-file (expand-file-name "ph-custom.el" ph-custom-dir)
  "This file is phchang's personal customization file.")

(defun ph-open-my-custom-file ()
  "Edit the `ph-custom-file`, in another window. If there is 
is only one visible window, it will split another one window 
at right"
  (interactive)
  (if (= (count-windows) 1)
      (split-window-right))
  (find-file-other-window ph-custom-file))

;; set global keybinding
(global-set-key (kbd "C-c 1") 'ph-open-my-custom-file)

;; set rainbow mode to css hook
(add-hook 'css-mode-hook 'rainbow-mode)

;; start emacs server
(server-start)

(provide 'ph-custom)
;;; ph-custom.el ends here


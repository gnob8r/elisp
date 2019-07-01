;; https://github.com/mnp/dispwatch
(defun rwd/display-change (disp)
  (interactive)
  (let ((disp (dispwatch--get-display)))
    ;; TODO: adapt and fold these in
   (cond ((equal disp "1440x900")
          (setq split-height-threshold 80 ; the defaults
                split-width-threshold (* 2 80))
          (rwd-set-mac-font "Menlo" 14))
         ((equal disp "4000x1440")
          (setq split-height-threshold (* 2 60)
                split-width-threshold (* 2 80))
          (rwd-set-mac-font "Menlo" 16))
         (t (find-function 'rwd/display-change)
            (error "Please add %S to rwd/display-change" disp)))
   (rwd-fix-fullscreen)
   (sleep-for 0.5)
   (rwd-split-smart)))

(require 'dispwatch)
;; TODO: move above to hook file
(add-hook 'dispwatch-display-change-hooks #'rwd/display-change)
(dispwatch-enable)

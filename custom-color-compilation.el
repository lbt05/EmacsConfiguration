(provide 'custom-color-compilation)

;;;; color spec output
(defun font-lock-proof (string start)
  (cond
   ((>= start (length string)) "")
   (t
    (let* ((end (next-property-change start string (length string)))
           (s (substring string start end)))
      (set-text-properties 0
                           (length s)
                           (substitute 'font-lock-face 'face (text-properties-at 0 s))
                           s)
      (concat s (font-lock-proof string end))))))

(defadvice compilation-filter (before ansify-compilation-output activate)
  (with-current-buffer (process-buffer (ad-get-arg 0))
    (let ((colorstr (ansi-color-apply (ad-get-arg 1))))
      (ad-set-arg 1 (font-lock-proof colorstr 0)))))

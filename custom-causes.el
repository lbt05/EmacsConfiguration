(provide 'custom-causes)
(require 'cl)

(defvar *devbox* "devbox"
  "Hostname of your remote development machine. <ssh *devbox*> must log you in without a password.")

(defun existing-buffer-on-host (host)
  "Finds and returns an existing buffer on `host`. Returns null if no such buffer exists."
  (car
   (let ((buffer-pattern (concat "/ssh:"
                                 host
                                 ":")))
     (remove-if-not (lambda (buf) (string-match buffer-pattern (buffer-file-name buf)))
                    (remove-if (lambda (buf) (null (buffer-file-name buf)))
                               (buffer-list))))))

(defun buffer-on-host (host)
  (or (existing-buffer-on-host host)
      (find-file-noselect (concat "/ssh:"
                                  host
                                  ":/tmp/emacs-tempfile"))))

(defun buffer-on-devbox ()
  "Returns a buffer on *devbox*. Creates one if necessary."
    (buffer-on-host *devbox*))


(defun compile-on-devbox (command)
  (with-current-buffer (buffer-on-devbox)
    (compile command)))

(defun reload-causes ()
  (interactive)
  (compile-on-devbox "touch ~/causes/tmp/restart.txt"))

(defun reload-wishes ()
  (interactive)
  (compile-on-devbox "touch ~/wishes/tmp/restart.txt"))

(global-set-key [(control ?\;) ?r ?c] 'reload-causes)
(global-set-key [(control ?\;) ?r ?w] 'reload-wishes)

;; Extension for EMACS org-mode that allows embedding layered SVG files
;; in reveal.js presentation slides.
;; Each layer will become an entry in an reveal.js r-stack.
;; A. Schlemmer, 04/2021

;; org-export-current-backend

(defconst script-path (file-name-directory (or load-file-name buffer-file-name)))

(defun split-slides-with-script (filename regen)
  (if (or (string-equal regen "true") (not (file-directory-p filename)))
            (progn
              (message "Layers are extracted...")
              (shell-command (concat script-path "split_slide.sh " filename ".svg"))))
  )

(defun revealrstack (filename-relative size regen extension handout)
  "This function implements support for layered svg-slides.
   inkscape is used to extract the individual layers from an svg-file.
   The shell script 'split_slide.sh' is used to do that.
   This file has to be installed in the same directory as this elisp file.

   Parameters:
   FILENAME-RELATIVE: The relative filename of the SVG file.
   SIZE: The size used for the 'width' attribute in the resulting HTML file. Usually a percentage like \"80%\".
   REGEN: True or false. If false, the slides are only regenerated from the SVG file if they are not present yet. They are always regenerated otherwise.
   EXTENSION: Can be \"png\" or \"svg\". The chosen format will be used as the embedded image. Use PNG for more reliable cross-browser compatibility and SVG for a better resolution.
"
  (let ((filename (expand-file-name filename-relative)))
    (if (string-equal org-export-current-backend "reveal")
        (progn
        ;; (message "reveal-export")
        (split-slides-with-script filename regen)
      
        (concat "#+REVEAL_HTML: <div class=\"r-stack\">\n"
                (mapconcat #'identity
                           (seq-map (lambda (a)
                                      (concat "#+ATTR_HTML: :width "
                                              size " :class fragment\n[["
                                              filename-relative "/" a "]]\n"))
                                    (directory-files
                                     filename nil
                                     (concat "layer.*\\." extension)))
                           "")
                "#+REVEAL_HTML: </div>"))
      ;; for all other (than reveal) formats:
      (progn
        ;; (message "other-export")
        (split-slides-with-script filename regen)

        (if handout
        ;; Only the merged version for handouts:
          (concat "[[" filename-relative "/merged.pdf]]")

        ;; The overlay version:
          (mapconcat #'identity
                         (seq-map (lambda (a) 
                                    (concat "#+BEAMER: \\begin{textblock*}{\\linewidth}(1cm,1.2cm) "
                                            "\\includegraphics<+->[width=.9\\linewidth]{"
                                            filename-relative "/" a "}"
                                            "\\end{textblock*}\n"))
                                  (directory-files
                                   filename nil
                                   (concat "layer.*\\." extension)))
                         ""))
        )
      )))


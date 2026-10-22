(defun c:DeleteAllSolidHatches (/ ss i ent data blocks blk obj count)

  (vl-load-com)
  (setq count 0)

  ;; Удаляем SOLID-штриховки из модели и листов
  (if (setq ss (ssget "_X" '((0 . "HATCH") (2 . "SOLID"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (if (entdel ent)
          (setq count (1+ count))
        )
        (setq i (1+ i))
      )
    )
  )

  ;; Получаем определения блоков
  (setq blocks
    (vla-get-Blocks
      (vla-get-ActiveDocument
        (vlax-get-acad-object)
      )
    )
  )

  ;; Удаляем SOLID-штриховки внутри блоков
  (vlax-for blk blocks
    (if (and
          (= :vlax-false (vla-get-IsLayout blk))
          (= :vlax-false (vla-get-IsXRef blk))
        )
      (progn
        (vlax-for obj blk
          (if (and
                (= "AcDbHatch" (vla-get-ObjectName obj))
                (= "SOLID" (strcase (vla-get-PatternName obj)))
              )
            (progn
              (vla-delete obj)
              (setq count (1+ count))
            )
          )
        )
      )
    )
  )

  (princ
    (strcat
      "\nУдалено SOLID-штриховок: "
      (itoa count)
    )
  )
  (princ)
)
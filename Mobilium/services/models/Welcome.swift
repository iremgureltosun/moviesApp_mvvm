//
//  Welcome.swift
//  Mobilium
//
//  Created by irem TOSUN on 6.06.2022.
//

import Foundation

// MARK: - Welcome

public struct Welcome: Codable {
    let dates: Dates
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates

struct Dates: Codable {
    let maximum, minimum: String
}


enum OriginalLanguage: String, Codable  {
    case ab
    case aa
    case af
    case ak
    case sq
    case am
    case ar
    case an
    case hy
    case `as`
    case av
    case ae
    case ay
    case az
    case bm
    case ba
    case eu
    case be
    case bn
    case bh
    case bi
    case bs
    case br
    case bg
    case my
    case ca
    case ch
    case ce
    case ny
    case zh
    case cv
    case kw
    case co
    case cr
    case hr
    case cs
    case da
    case dv
    case nl
    case dz
    case en
    case eo
    case et
    case ee
    case fo
    case fj
    case fi
    case fr
    case ff 
    case gl
    case ka
    case de
    case el
    case gn
    case gu
    case ht
    case ha
    case he
    case hz
    case hi
    case ho
    case hu
    case ia
    case id
    case ie
    case ga
    case ig
    case ik
    case io
    case `is`
    case it
    case iu
    case ja
    case jv
    case kl
    case kn
    case kr
    case ks
    case kk
    case km
    case ki
    case rw
    case ky
    case kv
    case kg
    case ko
    case ku
    case kj
    case la
    case lb
    case lg
    case li
    case ln
    case lo
    case lt
    case lu
    case lv
    case gv
    case mk
    case mg
    case ms
    case ml
    case mt
    case mi
    case mr
    case mh
    case mn
    case na
    case nv
    case nd
    case ne
    case ng
    case nb
    case nn
    case no
    case ii
    case nr
    case oc
    case oj
    case cu
    case om
    case or
    case os
    case pa
    case pi
    case fa
    case pox
    case pl
    case ps
    case pt
    case qu
    case rm
    case rn
    case ro
    case ru
    case sa
    case sc
    case sd
    case se
    case sm
    case sg
    case sr
    case gd
    case sn
    case si
    case sk
    case sl
    case so
    case st
    case es
    case su
    case sw
    case ss
    case sv
    case ta
    case te
    case tg
    case th
    case ti
    case bo
    case tk
    case tl
    case tn
    case to
    case tr
    case ts
    case tt
    case tw
    case ty
    case ug
    case uk
    case ur
    case uz
    case ve
    case vi
    case vo
    case wa
    case cy
    case wo
    case fy
    case xh
    case yi
    case yo
    case za
    case zu
}

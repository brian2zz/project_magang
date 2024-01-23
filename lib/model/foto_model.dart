class Foto {
    Foto({
        this.fotoId,
        this.fotoUrl,
    });

    String? fotoId;
    String? fotoUrl;

    factory Foto.fromJson(Map<String, dynamic> json) => Foto(
        fotoId: (json["foto_id"] == null) ? "" : json["foto_id"],
        fotoUrl: (json["foto_url"] == null) ? "" : json["foto_url"],
    );
}